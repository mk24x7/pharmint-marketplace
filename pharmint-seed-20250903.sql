--
-- PostgreSQL database dump
--

\restrict mXgXcjmArXNP3EjK2NthlCC3TC7aDMzrLezhDejxLoL7eJCAfFehi0Lh1uwY7zf

-- Dumped from database version 17.6 (Postgres.app)
-- Dumped by pg_dump version 17.6 (Postgres.app)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: claim_reason_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.claim_reason_enum AS ENUM (
    'missing_item',
    'wrong_item',
    'production_failure',
    'other'
);


ALTER TYPE public.claim_reason_enum OWNER TO postgres;

--
-- Name: order_claim_type_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.order_claim_type_enum AS ENUM (
    'refund',
    'replace'
);


ALTER TYPE public.order_claim_type_enum OWNER TO postgres;

--
-- Name: order_status_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.order_status_enum AS ENUM (
    'pending',
    'completed',
    'draft',
    'archived',
    'canceled',
    'requires_action'
);


ALTER TYPE public.order_status_enum OWNER TO postgres;

--
-- Name: return_status_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.return_status_enum AS ENUM (
    'open',
    'requested',
    'received',
    'partially_received',
    'canceled'
);


ALTER TYPE public.return_status_enum OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: account_holder; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.account_holder (
    id text NOT NULL,
    provider_id text NOT NULL,
    external_id text NOT NULL,
    email text,
    data jsonb DEFAULT '{}'::jsonb NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.account_holder OWNER TO postgres;

--
-- Name: api_key; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.api_key (
    id text NOT NULL,
    token text NOT NULL,
    salt text NOT NULL,
    redacted text NOT NULL,
    title text NOT NULL,
    type text NOT NULL,
    last_used_at timestamp with time zone,
    created_by text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    revoked_by text,
    revoked_at timestamp with time zone,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    CONSTRAINT api_key_type_check CHECK ((type = ANY (ARRAY['publishable'::text, 'secret'::text])))
);


ALTER TABLE public.api_key OWNER TO postgres;

--
-- Name: application_method_buy_rules; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.application_method_buy_rules (
    application_method_id text NOT NULL,
    promotion_rule_id text NOT NULL
);


ALTER TABLE public.application_method_buy_rules OWNER TO postgres;

--
-- Name: application_method_target_rules; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.application_method_target_rules (
    application_method_id text NOT NULL,
    promotion_rule_id text NOT NULL
);


ALTER TABLE public.application_method_target_rules OWNER TO postgres;

--
-- Name: auth_identity; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.auth_identity (
    id text NOT NULL,
    app_metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.auth_identity OWNER TO postgres;

--
-- Name: capture; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.capture (
    id text NOT NULL,
    amount numeric NOT NULL,
    raw_amount jsonb NOT NULL,
    payment_id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    created_by text,
    metadata jsonb
);


ALTER TABLE public.capture OWNER TO postgres;

--
-- Name: cart; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cart (
    id text NOT NULL,
    region_id text,
    customer_id text,
    sales_channel_id text,
    email text,
    currency_code text NOT NULL,
    shipping_address_id text,
    billing_address_id text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    completed_at timestamp with time zone
);


ALTER TABLE public.cart OWNER TO postgres;

--
-- Name: cart_address; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cart_address (
    id text NOT NULL,
    customer_id text,
    company text,
    first_name text,
    last_name text,
    address_1 text,
    address_2 text,
    city text,
    country_code text,
    province text,
    postal_code text,
    phone text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.cart_address OWNER TO postgres;

--
-- Name: cart_line_item; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cart_line_item (
    id text NOT NULL,
    cart_id text NOT NULL,
    title text NOT NULL,
    subtitle text,
    thumbnail text,
    quantity integer NOT NULL,
    variant_id text,
    product_id text,
    product_title text,
    product_description text,
    product_subtitle text,
    product_type text,
    product_collection text,
    product_handle text,
    variant_sku text,
    variant_barcode text,
    variant_title text,
    variant_option_values jsonb,
    requires_shipping boolean DEFAULT true NOT NULL,
    is_discountable boolean DEFAULT true NOT NULL,
    is_tax_inclusive boolean DEFAULT false NOT NULL,
    compare_at_unit_price numeric,
    raw_compare_at_unit_price jsonb,
    unit_price numeric NOT NULL,
    raw_unit_price jsonb NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    product_type_id text,
    is_custom_price boolean DEFAULT false NOT NULL,
    is_giftcard boolean DEFAULT false NOT NULL,
    CONSTRAINT cart_line_item_unit_price_check CHECK ((unit_price >= (0)::numeric))
);


ALTER TABLE public.cart_line_item OWNER TO postgres;

--
-- Name: cart_line_item_adjustment; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cart_line_item_adjustment (
    id text NOT NULL,
    description text,
    promotion_id text,
    code text,
    amount numeric NOT NULL,
    raw_amount jsonb NOT NULL,
    provider_id text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    item_id text,
    is_tax_inclusive boolean DEFAULT false NOT NULL,
    CONSTRAINT cart_line_item_adjustment_check CHECK ((amount >= (0)::numeric))
);


ALTER TABLE public.cart_line_item_adjustment OWNER TO postgres;

--
-- Name: cart_line_item_tax_line; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cart_line_item_tax_line (
    id text NOT NULL,
    description text,
    tax_rate_id text,
    code text NOT NULL,
    rate real NOT NULL,
    provider_id text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    item_id text
);


ALTER TABLE public.cart_line_item_tax_line OWNER TO postgres;

--
-- Name: cart_payment_collection; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cart_payment_collection (
    cart_id character varying(255) NOT NULL,
    payment_collection_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.cart_payment_collection OWNER TO postgres;

--
-- Name: cart_promotion; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cart_promotion (
    cart_id character varying(255) NOT NULL,
    promotion_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.cart_promotion OWNER TO postgres;

--
-- Name: cart_shipping_method; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cart_shipping_method (
    id text NOT NULL,
    cart_id text NOT NULL,
    name text NOT NULL,
    description jsonb,
    amount numeric NOT NULL,
    raw_amount jsonb NOT NULL,
    is_tax_inclusive boolean DEFAULT false NOT NULL,
    shipping_option_id text,
    data jsonb,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    CONSTRAINT cart_shipping_method_check CHECK ((amount >= (0)::numeric))
);


ALTER TABLE public.cart_shipping_method OWNER TO postgres;

--
-- Name: cart_shipping_method_adjustment; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cart_shipping_method_adjustment (
    id text NOT NULL,
    description text,
    promotion_id text,
    code text,
    amount numeric NOT NULL,
    raw_amount jsonb NOT NULL,
    provider_id text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    shipping_method_id text
);


ALTER TABLE public.cart_shipping_method_adjustment OWNER TO postgres;

--
-- Name: cart_shipping_method_tax_line; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cart_shipping_method_tax_line (
    id text NOT NULL,
    description text,
    tax_rate_id text,
    code text NOT NULL,
    rate real NOT NULL,
    provider_id text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    shipping_method_id text
);


ALTER TABLE public.cart_shipping_method_tax_line OWNER TO postgres;

--
-- Name: credit_line; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.credit_line (
    id text NOT NULL,
    cart_id text NOT NULL,
    reference text,
    reference_id text,
    amount numeric NOT NULL,
    raw_amount jsonb NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.credit_line OWNER TO postgres;

--
-- Name: currency; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.currency (
    code text NOT NULL,
    symbol text NOT NULL,
    symbol_native text NOT NULL,
    decimal_digits integer DEFAULT 0 NOT NULL,
    rounding numeric DEFAULT 0 NOT NULL,
    raw_rounding jsonb NOT NULL,
    name text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.currency OWNER TO postgres;

--
-- Name: customer; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.customer (
    id text NOT NULL,
    company_name text,
    first_name text,
    last_name text,
    email text,
    phone text,
    has_account boolean DEFAULT false NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    created_by text
);


ALTER TABLE public.customer OWNER TO postgres;

--
-- Name: customer_account_holder; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.customer_account_holder (
    customer_id character varying(255) NOT NULL,
    account_holder_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.customer_account_holder OWNER TO postgres;

--
-- Name: customer_address; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.customer_address (
    id text NOT NULL,
    customer_id text NOT NULL,
    address_name text,
    is_default_shipping boolean DEFAULT false NOT NULL,
    is_default_billing boolean DEFAULT false NOT NULL,
    company text,
    first_name text,
    last_name text,
    address_1 text,
    address_2 text,
    city text,
    country_code text,
    province text,
    postal_code text,
    phone text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.customer_address OWNER TO postgres;

--
-- Name: customer_group; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.customer_group (
    id text NOT NULL,
    name text NOT NULL,
    metadata jsonb,
    created_by text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.customer_group OWNER TO postgres;

--
-- Name: customer_group_customer; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.customer_group_customer (
    id text NOT NULL,
    customer_id text NOT NULL,
    customer_group_id text NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by text,
    deleted_at timestamp with time zone
);


ALTER TABLE public.customer_group_customer OWNER TO postgres;

--
-- Name: fulfillment; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.fulfillment (
    id text NOT NULL,
    location_id text NOT NULL,
    packed_at timestamp with time zone,
    shipped_at timestamp with time zone,
    delivered_at timestamp with time zone,
    canceled_at timestamp with time zone,
    data jsonb,
    provider_id text,
    shipping_option_id text,
    metadata jsonb,
    delivery_address_id text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    marked_shipped_by text,
    created_by text,
    requires_shipping boolean DEFAULT true NOT NULL
);


ALTER TABLE public.fulfillment OWNER TO postgres;

--
-- Name: fulfillment_address; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.fulfillment_address (
    id text NOT NULL,
    company text,
    first_name text,
    last_name text,
    address_1 text,
    address_2 text,
    city text,
    country_code text,
    province text,
    postal_code text,
    phone text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.fulfillment_address OWNER TO postgres;

--
-- Name: fulfillment_item; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.fulfillment_item (
    id text NOT NULL,
    title text NOT NULL,
    sku text NOT NULL,
    barcode text NOT NULL,
    quantity numeric NOT NULL,
    raw_quantity jsonb NOT NULL,
    line_item_id text,
    inventory_item_id text,
    fulfillment_id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.fulfillment_item OWNER TO postgres;

--
-- Name: fulfillment_label; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.fulfillment_label (
    id text NOT NULL,
    tracking_number text NOT NULL,
    tracking_url text NOT NULL,
    label_url text NOT NULL,
    fulfillment_id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.fulfillment_label OWNER TO postgres;

--
-- Name: fulfillment_provider; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.fulfillment_provider (
    id text NOT NULL,
    is_enabled boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.fulfillment_provider OWNER TO postgres;

--
-- Name: fulfillment_set; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.fulfillment_set (
    id text NOT NULL,
    name text NOT NULL,
    type text NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.fulfillment_set OWNER TO postgres;

--
-- Name: geo_zone; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.geo_zone (
    id text NOT NULL,
    type text DEFAULT 'country'::text NOT NULL,
    country_code text NOT NULL,
    province_code text,
    city text,
    service_zone_id text NOT NULL,
    postal_expression jsonb,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    CONSTRAINT geo_zone_type_check CHECK ((type = ANY (ARRAY['country'::text, 'province'::text, 'city'::text, 'zip'::text])))
);


ALTER TABLE public.geo_zone OWNER TO postgres;

--
-- Name: image; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.image (
    id text NOT NULL,
    url text NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    rank integer DEFAULT 0 NOT NULL,
    product_id text NOT NULL
);


ALTER TABLE public.image OWNER TO postgres;

--
-- Name: inventory_item; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.inventory_item (
    id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    sku text,
    origin_country text,
    hs_code text,
    mid_code text,
    material text,
    weight integer,
    length integer,
    height integer,
    width integer,
    requires_shipping boolean DEFAULT true NOT NULL,
    description text,
    title text,
    thumbnail text,
    metadata jsonb
);


ALTER TABLE public.inventory_item OWNER TO postgres;

--
-- Name: inventory_level; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.inventory_level (
    id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    inventory_item_id text NOT NULL,
    location_id text NOT NULL,
    stocked_quantity numeric DEFAULT 0 NOT NULL,
    reserved_quantity numeric DEFAULT 0 NOT NULL,
    incoming_quantity numeric DEFAULT 0 NOT NULL,
    metadata jsonb,
    raw_stocked_quantity jsonb,
    raw_reserved_quantity jsonb,
    raw_incoming_quantity jsonb
);


ALTER TABLE public.inventory_level OWNER TO postgres;

--
-- Name: invite; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.invite (
    id text NOT NULL,
    email text NOT NULL,
    accepted boolean DEFAULT false NOT NULL,
    token text NOT NULL,
    expires_at timestamp with time zone NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.invite OWNER TO postgres;

--
-- Name: link_module_migrations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.link_module_migrations (
    id integer NOT NULL,
    table_name character varying(255) NOT NULL,
    link_descriptor jsonb DEFAULT '{}'::jsonb NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.link_module_migrations OWNER TO postgres;

--
-- Name: link_module_migrations_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.link_module_migrations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.link_module_migrations_id_seq OWNER TO postgres;

--
-- Name: link_module_migrations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.link_module_migrations_id_seq OWNED BY public.link_module_migrations.id;


--
-- Name: location_fulfillment_provider; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.location_fulfillment_provider (
    stock_location_id character varying(255) NOT NULL,
    fulfillment_provider_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.location_fulfillment_provider OWNER TO postgres;

--
-- Name: location_fulfillment_set; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.location_fulfillment_set (
    stock_location_id character varying(255) NOT NULL,
    fulfillment_set_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.location_fulfillment_set OWNER TO postgres;

--
-- Name: mikro_orm_migrations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.mikro_orm_migrations (
    id integer NOT NULL,
    name character varying(255),
    executed_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.mikro_orm_migrations OWNER TO postgres;

--
-- Name: mikro_orm_migrations_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.mikro_orm_migrations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.mikro_orm_migrations_id_seq OWNER TO postgres;

--
-- Name: mikro_orm_migrations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.mikro_orm_migrations_id_seq OWNED BY public.mikro_orm_migrations.id;


--
-- Name: notification; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.notification (
    id text NOT NULL,
    "to" text NOT NULL,
    channel text NOT NULL,
    template text NOT NULL,
    data jsonb,
    trigger_type text,
    resource_id text,
    resource_type text,
    receiver_id text,
    original_notification_id text,
    idempotency_key text,
    external_id text,
    provider_id text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    status text DEFAULT 'pending'::text NOT NULL,
    CONSTRAINT notification_status_check CHECK ((status = ANY (ARRAY['pending'::text, 'success'::text, 'failure'::text])))
);


ALTER TABLE public.notification OWNER TO postgres;

--
-- Name: notification_provider; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.notification_provider (
    id text NOT NULL,
    handle text NOT NULL,
    name text NOT NULL,
    is_enabled boolean DEFAULT true NOT NULL,
    channels text[] DEFAULT '{}'::text[] NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.notification_provider OWNER TO postgres;

--
-- Name: order; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."order" (
    id text NOT NULL,
    region_id text,
    display_id integer,
    customer_id text,
    version integer DEFAULT 1 NOT NULL,
    sales_channel_id text,
    status public.order_status_enum DEFAULT 'pending'::public.order_status_enum NOT NULL,
    is_draft_order boolean DEFAULT false NOT NULL,
    email text,
    currency_code text NOT NULL,
    shipping_address_id text,
    billing_address_id text,
    no_notification boolean,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    canceled_at timestamp with time zone
);


ALTER TABLE public."order" OWNER TO postgres;

--
-- Name: order_address; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_address (
    id text NOT NULL,
    customer_id text,
    company text,
    first_name text,
    last_name text,
    address_1 text,
    address_2 text,
    city text,
    country_code text,
    province text,
    postal_code text,
    phone text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.order_address OWNER TO postgres;

--
-- Name: order_cart; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_cart (
    order_id character varying(255) NOT NULL,
    cart_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.order_cart OWNER TO postgres;

--
-- Name: order_change; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_change (
    id text NOT NULL,
    order_id text NOT NULL,
    version integer NOT NULL,
    description text,
    status text DEFAULT 'pending'::text NOT NULL,
    internal_note text,
    created_by text,
    requested_by text,
    requested_at timestamp with time zone,
    confirmed_by text,
    confirmed_at timestamp with time zone,
    declined_by text,
    declined_reason text,
    metadata jsonb,
    declined_at timestamp with time zone,
    canceled_by text,
    canceled_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    change_type text,
    deleted_at timestamp with time zone,
    return_id text,
    claim_id text,
    exchange_id text,
    CONSTRAINT order_change_status_check CHECK ((status = ANY (ARRAY['confirmed'::text, 'declined'::text, 'requested'::text, 'pending'::text, 'canceled'::text])))
);


ALTER TABLE public.order_change OWNER TO postgres;

--
-- Name: order_change_action; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_change_action (
    id text NOT NULL,
    order_id text,
    version integer,
    ordering bigint NOT NULL,
    order_change_id text,
    reference text,
    reference_id text,
    action text NOT NULL,
    details jsonb,
    amount numeric,
    raw_amount jsonb,
    internal_note text,
    applied boolean DEFAULT false NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    return_id text,
    claim_id text,
    exchange_id text
);


ALTER TABLE public.order_change_action OWNER TO postgres;

--
-- Name: order_change_action_ordering_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.order_change_action_ordering_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.order_change_action_ordering_seq OWNER TO postgres;

--
-- Name: order_change_action_ordering_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.order_change_action_ordering_seq OWNED BY public.order_change_action.ordering;


--
-- Name: order_claim; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_claim (
    id text NOT NULL,
    order_id text NOT NULL,
    return_id text,
    order_version integer NOT NULL,
    display_id integer NOT NULL,
    type public.order_claim_type_enum NOT NULL,
    no_notification boolean,
    refund_amount numeric,
    raw_refund_amount jsonb,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    canceled_at timestamp with time zone,
    created_by text
);


ALTER TABLE public.order_claim OWNER TO postgres;

--
-- Name: order_claim_display_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.order_claim_display_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.order_claim_display_id_seq OWNER TO postgres;

--
-- Name: order_claim_display_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.order_claim_display_id_seq OWNED BY public.order_claim.display_id;


--
-- Name: order_claim_item; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_claim_item (
    id text NOT NULL,
    claim_id text NOT NULL,
    item_id text NOT NULL,
    is_additional_item boolean DEFAULT false NOT NULL,
    reason public.claim_reason_enum,
    quantity numeric NOT NULL,
    raw_quantity jsonb NOT NULL,
    note text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.order_claim_item OWNER TO postgres;

--
-- Name: order_claim_item_image; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_claim_item_image (
    id text NOT NULL,
    claim_item_id text NOT NULL,
    url text NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.order_claim_item_image OWNER TO postgres;

--
-- Name: order_credit_line; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_credit_line (
    id text NOT NULL,
    order_id text NOT NULL,
    reference text,
    reference_id text,
    amount numeric NOT NULL,
    raw_amount jsonb NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.order_credit_line OWNER TO postgres;

--
-- Name: order_display_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.order_display_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.order_display_id_seq OWNER TO postgres;

--
-- Name: order_display_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.order_display_id_seq OWNED BY public."order".display_id;


--
-- Name: order_exchange; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_exchange (
    id text NOT NULL,
    order_id text NOT NULL,
    return_id text,
    order_version integer NOT NULL,
    display_id integer NOT NULL,
    no_notification boolean,
    allow_backorder boolean DEFAULT false NOT NULL,
    difference_due numeric,
    raw_difference_due jsonb,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    canceled_at timestamp with time zone,
    created_by text
);


ALTER TABLE public.order_exchange OWNER TO postgres;

--
-- Name: order_exchange_display_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.order_exchange_display_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.order_exchange_display_id_seq OWNER TO postgres;

--
-- Name: order_exchange_display_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.order_exchange_display_id_seq OWNED BY public.order_exchange.display_id;


--
-- Name: order_exchange_item; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_exchange_item (
    id text NOT NULL,
    exchange_id text NOT NULL,
    item_id text NOT NULL,
    quantity numeric NOT NULL,
    raw_quantity jsonb NOT NULL,
    note text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.order_exchange_item OWNER TO postgres;

--
-- Name: order_fulfillment; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_fulfillment (
    order_id character varying(255) NOT NULL,
    fulfillment_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.order_fulfillment OWNER TO postgres;

--
-- Name: order_item; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_item (
    id text NOT NULL,
    order_id text NOT NULL,
    version integer NOT NULL,
    item_id text NOT NULL,
    quantity numeric NOT NULL,
    raw_quantity jsonb NOT NULL,
    fulfilled_quantity numeric NOT NULL,
    raw_fulfilled_quantity jsonb NOT NULL,
    shipped_quantity numeric NOT NULL,
    raw_shipped_quantity jsonb NOT NULL,
    return_requested_quantity numeric NOT NULL,
    raw_return_requested_quantity jsonb NOT NULL,
    return_received_quantity numeric NOT NULL,
    raw_return_received_quantity jsonb NOT NULL,
    return_dismissed_quantity numeric NOT NULL,
    raw_return_dismissed_quantity jsonb NOT NULL,
    written_off_quantity numeric NOT NULL,
    raw_written_off_quantity jsonb NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    delivered_quantity numeric DEFAULT 0 NOT NULL,
    raw_delivered_quantity jsonb NOT NULL,
    unit_price numeric,
    raw_unit_price jsonb,
    compare_at_unit_price numeric,
    raw_compare_at_unit_price jsonb
);


ALTER TABLE public.order_item OWNER TO postgres;

--
-- Name: order_line_item; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_line_item (
    id text NOT NULL,
    totals_id text,
    title text NOT NULL,
    subtitle text,
    thumbnail text,
    variant_id text,
    product_id text,
    product_title text,
    product_description text,
    product_subtitle text,
    product_type text,
    product_collection text,
    product_handle text,
    variant_sku text,
    variant_barcode text,
    variant_title text,
    variant_option_values jsonb,
    requires_shipping boolean DEFAULT true NOT NULL,
    is_discountable boolean DEFAULT true NOT NULL,
    is_tax_inclusive boolean DEFAULT false NOT NULL,
    compare_at_unit_price numeric,
    raw_compare_at_unit_price jsonb,
    unit_price numeric NOT NULL,
    raw_unit_price jsonb NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    is_custom_price boolean DEFAULT false NOT NULL,
    product_type_id text,
    is_giftcard boolean DEFAULT false NOT NULL
);


ALTER TABLE public.order_line_item OWNER TO postgres;

--
-- Name: order_line_item_adjustment; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_line_item_adjustment (
    id text NOT NULL,
    description text,
    promotion_id text,
    code text,
    amount numeric NOT NULL,
    raw_amount jsonb NOT NULL,
    provider_id text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    item_id text NOT NULL,
    deleted_at timestamp with time zone,
    is_tax_inclusive boolean DEFAULT false NOT NULL
);


ALTER TABLE public.order_line_item_adjustment OWNER TO postgres;

--
-- Name: order_line_item_tax_line; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_line_item_tax_line (
    id text NOT NULL,
    description text,
    tax_rate_id text,
    code text NOT NULL,
    rate numeric NOT NULL,
    raw_rate jsonb NOT NULL,
    provider_id text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    item_id text NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.order_line_item_tax_line OWNER TO postgres;

--
-- Name: order_payment_collection; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_payment_collection (
    order_id character varying(255) NOT NULL,
    payment_collection_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.order_payment_collection OWNER TO postgres;

--
-- Name: order_promotion; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_promotion (
    order_id character varying(255) NOT NULL,
    promotion_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.order_promotion OWNER TO postgres;

--
-- Name: order_shipping; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_shipping (
    id text NOT NULL,
    order_id text NOT NULL,
    version integer NOT NULL,
    shipping_method_id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    return_id text,
    claim_id text,
    exchange_id text
);


ALTER TABLE public.order_shipping OWNER TO postgres;

--
-- Name: order_shipping_method; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_shipping_method (
    id text NOT NULL,
    name text NOT NULL,
    description jsonb,
    amount numeric NOT NULL,
    raw_amount jsonb NOT NULL,
    is_tax_inclusive boolean DEFAULT false NOT NULL,
    shipping_option_id text,
    data jsonb,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    is_custom_amount boolean DEFAULT false NOT NULL
);


ALTER TABLE public.order_shipping_method OWNER TO postgres;

--
-- Name: order_shipping_method_adjustment; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_shipping_method_adjustment (
    id text NOT NULL,
    description text,
    promotion_id text,
    code text,
    amount numeric NOT NULL,
    raw_amount jsonb NOT NULL,
    provider_id text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    shipping_method_id text NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.order_shipping_method_adjustment OWNER TO postgres;

--
-- Name: order_shipping_method_tax_line; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_shipping_method_tax_line (
    id text NOT NULL,
    description text,
    tax_rate_id text,
    code text NOT NULL,
    rate numeric NOT NULL,
    raw_rate jsonb NOT NULL,
    provider_id text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    shipping_method_id text NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.order_shipping_method_tax_line OWNER TO postgres;

--
-- Name: order_summary; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_summary (
    id text NOT NULL,
    order_id text NOT NULL,
    version integer DEFAULT 1 NOT NULL,
    totals jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.order_summary OWNER TO postgres;

--
-- Name: order_transaction; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_transaction (
    id text NOT NULL,
    order_id text NOT NULL,
    version integer DEFAULT 1 NOT NULL,
    amount numeric NOT NULL,
    raw_amount jsonb NOT NULL,
    currency_code text NOT NULL,
    reference text,
    reference_id text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    return_id text,
    claim_id text,
    exchange_id text
);


ALTER TABLE public.order_transaction OWNER TO postgres;

--
-- Name: payment; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.payment (
    id text NOT NULL,
    amount numeric NOT NULL,
    raw_amount jsonb NOT NULL,
    currency_code text NOT NULL,
    provider_id text NOT NULL,
    data jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    captured_at timestamp with time zone,
    canceled_at timestamp with time zone,
    payment_collection_id text NOT NULL,
    payment_session_id text NOT NULL,
    metadata jsonb
);


ALTER TABLE public.payment OWNER TO postgres;

--
-- Name: payment_collection; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.payment_collection (
    id text NOT NULL,
    currency_code text NOT NULL,
    amount numeric NOT NULL,
    raw_amount jsonb NOT NULL,
    authorized_amount numeric,
    raw_authorized_amount jsonb,
    captured_amount numeric,
    raw_captured_amount jsonb,
    refunded_amount numeric,
    raw_refunded_amount jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    completed_at timestamp with time zone,
    status text DEFAULT 'not_paid'::text NOT NULL,
    metadata jsonb,
    CONSTRAINT payment_collection_status_check CHECK ((status = ANY (ARRAY['not_paid'::text, 'awaiting'::text, 'authorized'::text, 'partially_authorized'::text, 'canceled'::text, 'failed'::text, 'partially_captured'::text, 'completed'::text])))
);


ALTER TABLE public.payment_collection OWNER TO postgres;

--
-- Name: payment_collection_payment_providers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.payment_collection_payment_providers (
    payment_collection_id text NOT NULL,
    payment_provider_id text NOT NULL
);


ALTER TABLE public.payment_collection_payment_providers OWNER TO postgres;

--
-- Name: payment_provider; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.payment_provider (
    id text NOT NULL,
    is_enabled boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.payment_provider OWNER TO postgres;

--
-- Name: payment_session; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.payment_session (
    id text NOT NULL,
    currency_code text NOT NULL,
    amount numeric NOT NULL,
    raw_amount jsonb NOT NULL,
    provider_id text NOT NULL,
    data jsonb DEFAULT '{}'::jsonb NOT NULL,
    context jsonb,
    status text DEFAULT 'pending'::text NOT NULL,
    authorized_at timestamp with time zone,
    payment_collection_id text NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    CONSTRAINT payment_session_status_check CHECK ((status = ANY (ARRAY['authorized'::text, 'captured'::text, 'pending'::text, 'requires_more'::text, 'error'::text, 'canceled'::text])))
);


ALTER TABLE public.payment_session OWNER TO postgres;

--
-- Name: price; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.price (
    id text NOT NULL,
    title text,
    price_set_id text NOT NULL,
    currency_code text NOT NULL,
    raw_amount jsonb NOT NULL,
    rules_count integer DEFAULT 0,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    price_list_id text,
    amount numeric NOT NULL,
    min_quantity integer,
    max_quantity integer
);


ALTER TABLE public.price OWNER TO postgres;

--
-- Name: price_list; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.price_list (
    id text NOT NULL,
    status text DEFAULT 'draft'::text NOT NULL,
    starts_at timestamp with time zone,
    ends_at timestamp with time zone,
    rules_count integer DEFAULT 0,
    title text NOT NULL,
    description text NOT NULL,
    type text DEFAULT 'sale'::text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    CONSTRAINT price_list_status_check CHECK ((status = ANY (ARRAY['active'::text, 'draft'::text]))),
    CONSTRAINT price_list_type_check CHECK ((type = ANY (ARRAY['sale'::text, 'override'::text])))
);


ALTER TABLE public.price_list OWNER TO postgres;

--
-- Name: price_list_rule; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.price_list_rule (
    id text NOT NULL,
    price_list_id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    value jsonb,
    attribute text DEFAULT ''::text NOT NULL
);


ALTER TABLE public.price_list_rule OWNER TO postgres;

--
-- Name: price_preference; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.price_preference (
    id text NOT NULL,
    attribute text NOT NULL,
    value text,
    is_tax_inclusive boolean DEFAULT false NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.price_preference OWNER TO postgres;

--
-- Name: price_rule; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.price_rule (
    id text NOT NULL,
    value text NOT NULL,
    priority integer DEFAULT 0 NOT NULL,
    price_id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    attribute text DEFAULT ''::text NOT NULL,
    operator text DEFAULT 'eq'::text NOT NULL,
    CONSTRAINT price_rule_operator_check CHECK ((operator = ANY (ARRAY['gte'::text, 'lte'::text, 'gt'::text, 'lt'::text, 'eq'::text])))
);


ALTER TABLE public.price_rule OWNER TO postgres;

--
-- Name: price_set; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.price_set (
    id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.price_set OWNER TO postgres;

--
-- Name: product; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product (
    id text NOT NULL,
    title text NOT NULL,
    handle text NOT NULL,
    subtitle text,
    description text,
    is_giftcard boolean DEFAULT false NOT NULL,
    status text DEFAULT 'draft'::text NOT NULL,
    thumbnail text,
    weight text,
    length text,
    height text,
    width text,
    origin_country text,
    hs_code text,
    mid_code text,
    material text,
    collection_id text,
    type_id text,
    discountable boolean DEFAULT true NOT NULL,
    external_id text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    metadata jsonb,
    CONSTRAINT product_status_check CHECK ((status = ANY (ARRAY['draft'::text, 'proposed'::text, 'published'::text, 'rejected'::text])))
);


ALTER TABLE public.product OWNER TO postgres;

--
-- Name: product_category; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product_category (
    id text NOT NULL,
    name text NOT NULL,
    description text DEFAULT ''::text NOT NULL,
    handle text NOT NULL,
    mpath text NOT NULL,
    is_active boolean DEFAULT false NOT NULL,
    is_internal boolean DEFAULT false NOT NULL,
    rank integer DEFAULT 0 NOT NULL,
    parent_category_id text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    metadata jsonb
);


ALTER TABLE public.product_category OWNER TO postgres;

--
-- Name: product_category_product; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product_category_product (
    product_id text NOT NULL,
    product_category_id text NOT NULL
);


ALTER TABLE public.product_category_product OWNER TO postgres;

--
-- Name: product_collection; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product_collection (
    id text NOT NULL,
    title text NOT NULL,
    handle text NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.product_collection OWNER TO postgres;

--
-- Name: product_option; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product_option (
    id text NOT NULL,
    title text NOT NULL,
    product_id text NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.product_option OWNER TO postgres;

--
-- Name: product_option_value; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product_option_value (
    id text NOT NULL,
    value text NOT NULL,
    option_id text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.product_option_value OWNER TO postgres;

--
-- Name: product_sales_channel; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product_sales_channel (
    product_id character varying(255) NOT NULL,
    sales_channel_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.product_sales_channel OWNER TO postgres;

--
-- Name: product_shipping_profile; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product_shipping_profile (
    product_id character varying(255) NOT NULL,
    shipping_profile_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.product_shipping_profile OWNER TO postgres;

--
-- Name: product_tag; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product_tag (
    id text NOT NULL,
    value text NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.product_tag OWNER TO postgres;

--
-- Name: product_tags; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product_tags (
    product_id text NOT NULL,
    product_tag_id text NOT NULL
);


ALTER TABLE public.product_tags OWNER TO postgres;

--
-- Name: product_type; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product_type (
    id text NOT NULL,
    value text NOT NULL,
    metadata json,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.product_type OWNER TO postgres;

--
-- Name: product_variant; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product_variant (
    id text NOT NULL,
    title text NOT NULL,
    sku text,
    barcode text,
    ean text,
    upc text,
    allow_backorder boolean DEFAULT false NOT NULL,
    manage_inventory boolean DEFAULT true NOT NULL,
    hs_code text,
    origin_country text,
    mid_code text,
    material text,
    weight integer,
    length integer,
    height integer,
    width integer,
    metadata jsonb,
    variant_rank integer DEFAULT 0,
    product_id text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.product_variant OWNER TO postgres;

--
-- Name: product_variant_inventory_item; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product_variant_inventory_item (
    variant_id character varying(255) NOT NULL,
    inventory_item_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    required_quantity integer DEFAULT 1 NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.product_variant_inventory_item OWNER TO postgres;

--
-- Name: product_variant_option; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product_variant_option (
    variant_id text NOT NULL,
    option_value_id text NOT NULL
);


ALTER TABLE public.product_variant_option OWNER TO postgres;

--
-- Name: product_variant_price_set; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product_variant_price_set (
    variant_id character varying(255) NOT NULL,
    price_set_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.product_variant_price_set OWNER TO postgres;

--
-- Name: promotion; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.promotion (
    id text NOT NULL,
    code text NOT NULL,
    campaign_id text,
    is_automatic boolean DEFAULT false NOT NULL,
    type text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    status text DEFAULT 'draft'::text NOT NULL,
    is_tax_inclusive boolean DEFAULT false NOT NULL,
    CONSTRAINT promotion_status_check CHECK ((status = ANY (ARRAY['draft'::text, 'active'::text, 'inactive'::text]))),
    CONSTRAINT promotion_type_check CHECK ((type = ANY (ARRAY['standard'::text, 'buyget'::text])))
);


ALTER TABLE public.promotion OWNER TO postgres;

--
-- Name: promotion_application_method; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.promotion_application_method (
    id text NOT NULL,
    value numeric,
    raw_value jsonb,
    max_quantity integer,
    apply_to_quantity integer,
    buy_rules_min_quantity integer,
    type text NOT NULL,
    target_type text NOT NULL,
    allocation text,
    promotion_id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    currency_code text,
    CONSTRAINT promotion_application_method_allocation_check CHECK ((allocation = ANY (ARRAY['each'::text, 'across'::text]))),
    CONSTRAINT promotion_application_method_target_type_check CHECK ((target_type = ANY (ARRAY['order'::text, 'shipping_methods'::text, 'items'::text]))),
    CONSTRAINT promotion_application_method_type_check CHECK ((type = ANY (ARRAY['fixed'::text, 'percentage'::text])))
);


ALTER TABLE public.promotion_application_method OWNER TO postgres;

--
-- Name: promotion_campaign; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.promotion_campaign (
    id text NOT NULL,
    name text NOT NULL,
    description text,
    campaign_identifier text NOT NULL,
    starts_at timestamp with time zone,
    ends_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.promotion_campaign OWNER TO postgres;

--
-- Name: promotion_campaign_budget; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.promotion_campaign_budget (
    id text NOT NULL,
    type text NOT NULL,
    campaign_id text NOT NULL,
    "limit" numeric,
    raw_limit jsonb,
    used numeric DEFAULT 0 NOT NULL,
    raw_used jsonb NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    currency_code text,
    CONSTRAINT promotion_campaign_budget_type_check CHECK ((type = ANY (ARRAY['spend'::text, 'usage'::text])))
);


ALTER TABLE public.promotion_campaign_budget OWNER TO postgres;

--
-- Name: promotion_promotion_rule; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.promotion_promotion_rule (
    promotion_id text NOT NULL,
    promotion_rule_id text NOT NULL
);


ALTER TABLE public.promotion_promotion_rule OWNER TO postgres;

--
-- Name: promotion_rule; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.promotion_rule (
    id text NOT NULL,
    description text,
    attribute text NOT NULL,
    operator text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    CONSTRAINT promotion_rule_operator_check CHECK ((operator = ANY (ARRAY['gte'::text, 'lte'::text, 'gt'::text, 'lt'::text, 'eq'::text, 'ne'::text, 'in'::text])))
);


ALTER TABLE public.promotion_rule OWNER TO postgres;

--
-- Name: promotion_rule_value; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.promotion_rule_value (
    id text NOT NULL,
    promotion_rule_id text NOT NULL,
    value text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.promotion_rule_value OWNER TO postgres;

--
-- Name: provider_identity; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.provider_identity (
    id text NOT NULL,
    entity_id text NOT NULL,
    provider text NOT NULL,
    auth_identity_id text NOT NULL,
    user_metadata jsonb,
    provider_metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.provider_identity OWNER TO postgres;

--
-- Name: publishable_api_key_sales_channel; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.publishable_api_key_sales_channel (
    publishable_key_id character varying(255) NOT NULL,
    sales_channel_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.publishable_api_key_sales_channel OWNER TO postgres;

--
-- Name: refund; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.refund (
    id text NOT NULL,
    amount numeric NOT NULL,
    raw_amount jsonb NOT NULL,
    payment_id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    created_by text,
    metadata jsonb,
    refund_reason_id text,
    note text
);


ALTER TABLE public.refund OWNER TO postgres;

--
-- Name: refund_reason; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.refund_reason (
    id text NOT NULL,
    label text NOT NULL,
    description text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.refund_reason OWNER TO postgres;

--
-- Name: region; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.region (
    id text NOT NULL,
    name text NOT NULL,
    currency_code text NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    automatic_taxes boolean DEFAULT true NOT NULL
);


ALTER TABLE public.region OWNER TO postgres;

--
-- Name: region_country; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.region_country (
    iso_2 text NOT NULL,
    iso_3 text NOT NULL,
    num_code text NOT NULL,
    name text NOT NULL,
    display_name text NOT NULL,
    region_id text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.region_country OWNER TO postgres;

--
-- Name: region_payment_provider; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.region_payment_provider (
    region_id character varying(255) NOT NULL,
    payment_provider_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.region_payment_provider OWNER TO postgres;

--
-- Name: reservation_item; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.reservation_item (
    id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    line_item_id text,
    location_id text NOT NULL,
    quantity numeric NOT NULL,
    external_id text,
    description text,
    created_by text,
    metadata jsonb,
    inventory_item_id text NOT NULL,
    allow_backorder boolean DEFAULT false,
    raw_quantity jsonb
);


ALTER TABLE public.reservation_item OWNER TO postgres;

--
-- Name: return; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.return (
    id text NOT NULL,
    order_id text NOT NULL,
    claim_id text,
    exchange_id text,
    order_version integer NOT NULL,
    display_id integer NOT NULL,
    status public.return_status_enum DEFAULT 'open'::public.return_status_enum NOT NULL,
    no_notification boolean,
    refund_amount numeric,
    raw_refund_amount jsonb,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    received_at timestamp with time zone,
    canceled_at timestamp with time zone,
    location_id text,
    requested_at timestamp with time zone,
    created_by text
);


ALTER TABLE public.return OWNER TO postgres;

--
-- Name: return_display_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.return_display_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.return_display_id_seq OWNER TO postgres;

--
-- Name: return_display_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.return_display_id_seq OWNED BY public.return.display_id;


--
-- Name: return_fulfillment; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.return_fulfillment (
    return_id character varying(255) NOT NULL,
    fulfillment_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.return_fulfillment OWNER TO postgres;

--
-- Name: return_item; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.return_item (
    id text NOT NULL,
    return_id text NOT NULL,
    reason_id text,
    item_id text NOT NULL,
    quantity numeric NOT NULL,
    raw_quantity jsonb NOT NULL,
    received_quantity numeric DEFAULT 0 NOT NULL,
    raw_received_quantity jsonb NOT NULL,
    note text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    damaged_quantity numeric DEFAULT 0 NOT NULL,
    raw_damaged_quantity jsonb NOT NULL
);


ALTER TABLE public.return_item OWNER TO postgres;

--
-- Name: return_reason; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.return_reason (
    id character varying NOT NULL,
    value character varying NOT NULL,
    label character varying NOT NULL,
    description character varying,
    metadata jsonb,
    parent_return_reason_id character varying,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.return_reason OWNER TO postgres;

--
-- Name: sales_channel; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sales_channel (
    id text NOT NULL,
    name text NOT NULL,
    description text,
    is_disabled boolean DEFAULT false NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.sales_channel OWNER TO postgres;

--
-- Name: sales_channel_stock_location; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sales_channel_stock_location (
    sales_channel_id character varying(255) NOT NULL,
    stock_location_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.sales_channel_stock_location OWNER TO postgres;

--
-- Name: script_migrations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.script_migrations (
    id integer NOT NULL,
    script_name character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    finished_at timestamp with time zone
);


ALTER TABLE public.script_migrations OWNER TO postgres;

--
-- Name: script_migrations_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.script_migrations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.script_migrations_id_seq OWNER TO postgres;

--
-- Name: script_migrations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.script_migrations_id_seq OWNED BY public.script_migrations.id;


--
-- Name: service_zone; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.service_zone (
    id text NOT NULL,
    name text NOT NULL,
    metadata jsonb,
    fulfillment_set_id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.service_zone OWNER TO postgres;

--
-- Name: shipping_option; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.shipping_option (
    id text NOT NULL,
    name text NOT NULL,
    price_type text DEFAULT 'flat'::text NOT NULL,
    service_zone_id text NOT NULL,
    shipping_profile_id text,
    provider_id text,
    data jsonb,
    metadata jsonb,
    shipping_option_type_id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    CONSTRAINT shipping_option_price_type_check CHECK ((price_type = ANY (ARRAY['calculated'::text, 'flat'::text])))
);


ALTER TABLE public.shipping_option OWNER TO postgres;

--
-- Name: shipping_option_price_set; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.shipping_option_price_set (
    shipping_option_id character varying(255) NOT NULL,
    price_set_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.shipping_option_price_set OWNER TO postgres;

--
-- Name: shipping_option_rule; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.shipping_option_rule (
    id text NOT NULL,
    attribute text NOT NULL,
    operator text NOT NULL,
    value jsonb,
    shipping_option_id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    CONSTRAINT shipping_option_rule_operator_check CHECK ((operator = ANY (ARRAY['in'::text, 'eq'::text, 'ne'::text, 'gt'::text, 'gte'::text, 'lt'::text, 'lte'::text, 'nin'::text])))
);


ALTER TABLE public.shipping_option_rule OWNER TO postgres;

--
-- Name: shipping_option_type; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.shipping_option_type (
    id text NOT NULL,
    label text NOT NULL,
    description text,
    code text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.shipping_option_type OWNER TO postgres;

--
-- Name: shipping_profile; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.shipping_profile (
    id text NOT NULL,
    name text NOT NULL,
    type text NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.shipping_profile OWNER TO postgres;

--
-- Name: stock_location; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.stock_location (
    id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    name text NOT NULL,
    address_id text,
    metadata jsonb
);


ALTER TABLE public.stock_location OWNER TO postgres;

--
-- Name: stock_location_address; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.stock_location_address (
    id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    address_1 text NOT NULL,
    address_2 text,
    company text,
    city text,
    country_code text NOT NULL,
    phone text,
    province text,
    postal_code text,
    metadata jsonb
);


ALTER TABLE public.stock_location_address OWNER TO postgres;

--
-- Name: store; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.store (
    id text NOT NULL,
    name text DEFAULT 'Medusa Store'::text NOT NULL,
    default_sales_channel_id text,
    default_region_id text,
    default_location_id text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.store OWNER TO postgres;

--
-- Name: store_currency; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.store_currency (
    id text NOT NULL,
    currency_code text NOT NULL,
    is_default boolean DEFAULT false NOT NULL,
    store_id text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.store_currency OWNER TO postgres;

--
-- Name: tax_provider; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tax_provider (
    id text NOT NULL,
    is_enabled boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.tax_provider OWNER TO postgres;

--
-- Name: tax_rate; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tax_rate (
    id text NOT NULL,
    rate real,
    code text NOT NULL,
    name text NOT NULL,
    is_default boolean DEFAULT false NOT NULL,
    is_combinable boolean DEFAULT false NOT NULL,
    tax_region_id text NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by text,
    deleted_at timestamp with time zone
);


ALTER TABLE public.tax_rate OWNER TO postgres;

--
-- Name: tax_rate_rule; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tax_rate_rule (
    id text NOT NULL,
    tax_rate_id text NOT NULL,
    reference_id text NOT NULL,
    reference text NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by text,
    deleted_at timestamp with time zone
);


ALTER TABLE public.tax_rate_rule OWNER TO postgres;

--
-- Name: tax_region; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tax_region (
    id text NOT NULL,
    provider_id text,
    country_code text NOT NULL,
    province_code text,
    parent_id text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by text,
    deleted_at timestamp with time zone,
    CONSTRAINT "CK_tax_region_country_top_level" CHECK (((parent_id IS NULL) OR (province_code IS NOT NULL))),
    CONSTRAINT "CK_tax_region_provider_top_level" CHECK (((parent_id IS NULL) OR (provider_id IS NULL)))
);


ALTER TABLE public.tax_region OWNER TO postgres;

--
-- Name: user; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."user" (
    id text NOT NULL,
    first_name text,
    last_name text,
    email text NOT NULL,
    avatar_url text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public."user" OWNER TO postgres;

--
-- Name: user_preference; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_preference (
    id text NOT NULL,
    user_id text NOT NULL,
    key text NOT NULL,
    value jsonb NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.user_preference OWNER TO postgres;

--
-- Name: view_configuration; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.view_configuration (
    id text NOT NULL,
    entity text NOT NULL,
    name text,
    user_id text,
    is_system_default boolean DEFAULT false NOT NULL,
    configuration jsonb NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.view_configuration OWNER TO postgres;

--
-- Name: workflow_execution; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.workflow_execution (
    id character varying NOT NULL,
    workflow_id character varying NOT NULL,
    transaction_id character varying NOT NULL,
    execution jsonb,
    context jsonb,
    state character varying NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    deleted_at timestamp without time zone,
    retention_time integer,
    run_id text DEFAULT '01K465NQ8R818FTA3966QJM0DX'::text NOT NULL
);


ALTER TABLE public.workflow_execution OWNER TO postgres;

--
-- Name: link_module_migrations id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.link_module_migrations ALTER COLUMN id SET DEFAULT nextval('public.link_module_migrations_id_seq'::regclass);


--
-- Name: mikro_orm_migrations id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mikro_orm_migrations ALTER COLUMN id SET DEFAULT nextval('public.mikro_orm_migrations_id_seq'::regclass);


--
-- Name: order display_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."order" ALTER COLUMN display_id SET DEFAULT nextval('public.order_display_id_seq'::regclass);


--
-- Name: order_change_action ordering; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_change_action ALTER COLUMN ordering SET DEFAULT nextval('public.order_change_action_ordering_seq'::regclass);


--
-- Name: order_claim display_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_claim ALTER COLUMN display_id SET DEFAULT nextval('public.order_claim_display_id_seq'::regclass);


--
-- Name: order_exchange display_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_exchange ALTER COLUMN display_id SET DEFAULT nextval('public.order_exchange_display_id_seq'::regclass);


--
-- Name: return display_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.return ALTER COLUMN display_id SET DEFAULT nextval('public.return_display_id_seq'::regclass);


--
-- Name: script_migrations id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.script_migrations ALTER COLUMN id SET DEFAULT nextval('public.script_migrations_id_seq'::regclass);


--
-- Data for Name: account_holder; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.account_holder (id, provider_id, external_id, email, data, metadata, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: api_key; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.api_key (id, token, salt, redacted, title, type, last_used_at, created_by, created_at, revoked_by, revoked_at, updated_at, deleted_at) FROM stdin;
apk_01K465NX1NM4WYMK1TC7WN4VMQ	pk_34d11f50308c12a3bf2e970e3759373236a288ec6d84d8e947436d8a0a74165b		pk_34d***65b	Webshop	publishable	\N		2025-09-03 03:05:11.413+05:30	\N	\N	2025-09-03 03:05:11.413+05:30	\N
\.


--
-- Data for Name: application_method_buy_rules; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.application_method_buy_rules (application_method_id, promotion_rule_id) FROM stdin;
\.


--
-- Data for Name: application_method_target_rules; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.application_method_target_rules (application_method_id, promotion_rule_id) FROM stdin;
\.


--
-- Data for Name: auth_identity; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.auth_identity (id, app_metadata, created_at, updated_at, deleted_at) FROM stdin;
authid_01K4699ZP44BNNFQAR83G0PD4N	{"user_id": "user_01K4699ZKG51FE37TNHEG4X7HR"}	2025-09-03 04:08:35.204+05:30	2025-09-03 04:08:35.212+05:30	\N
authid_01K46A3BATMFQ8REM2QGHTE64G	{"customer_id": "cus_01K46A3BBP2PYVPB81ECAQ2CVM"}	2025-09-03 04:22:26.331+05:30	2025-09-03 04:22:26.361+05:30	\N
\.


--
-- Data for Name: capture; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.capture (id, amount, raw_amount, payment_id, created_at, updated_at, deleted_at, created_by, metadata) FROM stdin;
capt_01K46C5845REFPVZPA9ZB0GZJ4	20	{"value": "20", "precision": 20}	pay_01K46A1CS3H2RF78M2C6RFHV9X	2025-09-03 04:58:25.733+05:30	2025-09-03 04:58:25.733+05:30	\N	\N	\N
\.


--
-- Data for Name: cart; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cart (id, region_id, customer_id, sales_channel_id, email, currency_code, shipping_address_id, billing_address_id, metadata, created_at, updated_at, deleted_at, completed_at) FROM stdin;
cart_01K466AXHFNSF95BC7REXFZ8B0	reg_01K465NWZBB589QBS334WRK4PF	cus_01K46A0ZPRWKCSMQAW51DY0W8R	sc_01K465NVAAFMSJ0RGP5VCKEPVH	mk@mk.com	eur	caaddr_01K46A0ZRNPRJP2YKVVCX2RH5W	caaddr_01K46A0ZRNDP5GCBE11PQBKJWC	\N	2025-09-03 03:16:40.049+05:30	2025-09-03 04:21:22.244+05:30	\N	2025-09-03 04:21:22.235+05:30
cart_01K46AAXHDHBT18YFJSZZDTR33	reg_01K465NWZBB589QBS334WRK4PF	cus_01K46A3BBP2PYVPB81ECAQ2CVM	sc_01K465NVAAFMSJ0RGP5VCKEPVH	mk24x7@gmail.com	eur	\N	\N	\N	2025-09-03 04:26:34.349+05:30	2025-09-03 04:26:34.349+05:30	\N	\N
cart_01K46AR6866A7DP2JNHJTC0G5Y	reg_01K46BWK51BRTM8J2035TXGP7Z	cus_01K46A3BBP2PYVPB81ECAQ2CVM	sc_01K465NVAAFMSJ0RGP5VCKEPVH	mk24x7@gmail.com	php	caaddr_01K46C2SYYEGPV1368S0HR6VDV	\N	\N	2025-09-03 04:33:49.255+05:30	2025-09-03 04:57:05.695+05:30	\N	\N
\.


--
-- Data for Name: cart_address; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cart_address (id, customer_id, company, first_name, last_name, address_1, address_2, city, country_code, province, postal_code, phone, metadata, created_at, updated_at, deleted_at) FROM stdin;
caaddr_01K46A0ZRNDP5GCBE11PQBKJWC	\N		test	test	test		varanasi	it	up	221002		\N	2025-09-03 04:21:08.95+05:30	2025-09-03 04:21:08.95+05:30	\N
caaddr_01K46A0ZRNPRJP2YKVVCX2RH5W	\N		test	test	test		varanasi	it	up	221002		\N	2025-09-03 04:21:08.95+05:30	2025-09-03 04:21:08.95+05:30	\N
caaddr_01K46C2SYYEGPV1368S0HR6VDV	\N	\N	\N	\N	\N	\N	\N	ph	\N	\N	\N	\N	2025-09-03 04:57:05.694+05:30	2025-09-03 04:57:05.694+05:30	\N
\.


--
-- Data for Name: cart_line_item; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cart_line_item (id, cart_id, title, subtitle, thumbnail, quantity, variant_id, product_id, product_title, product_description, product_subtitle, product_type, product_collection, product_handle, variant_sku, variant_barcode, variant_title, variant_option_values, requires_shipping, is_discountable, is_tax_inclusive, compare_at_unit_price, raw_compare_at_unit_price, unit_price, raw_unit_price, metadata, created_at, updated_at, deleted_at, product_type_id, is_custom_price, is_giftcard) FROM stdin;
cali_01K468ECQFE8SQKS9467B5AD66	cart_01K466AXHFNSF95BC7REXFZ8B0	Medusa T-Shirt	M / Black	https://medusa-public-images.s3.eu-west-1.amazonaws.com/tee-black-front.png	1	variant_01K465NX36QVW4VT9ZBR1WEYPA	prod_01K465NX26VFWW6C9Y3GJN3K6V	Medusa T-Shirt	Reimagine the feeling of a classic T-shirt. With our cotton T-shirts, everyday essentials no longer have to be ordinary.	\N	\N	\N	t-shirt	SHIRT-M-BLACK	\N	M / Black	\N	t	t	f	\N	\N	10	{"value": "10", "precision": 20}	{}	2025-09-03 03:53:31.055+05:30	2025-09-03 03:53:31.055+05:30	\N	\N	f	f
cali_01K466H63G0438W6NKATR69GJ2	cart_01K466AXHFNSF95BC7REXFZ8B0	Medusa Shorts	L	https://medusa-public-images.s3.eu-west-1.amazonaws.com/shorts-vintage-front.png	1	variant_01K465NX37MHFAWV23YEA6MZKQ	prod_01K465NX266PGFTQ8PFSGZS1R3	Medusa Shorts	Reimagine the feeling of classic shorts. With our cotton shorts, everyday essentials no longer have to be ordinary.	\N	\N	\N	shorts	SHORTS-L	\N	L	\N	t	t	f	\N	\N	10	{"value": "10", "precision": 20}	{}	2025-09-03 03:20:05.424+05:30	2025-09-03 04:14:17.456+05:30	2025-09-03 04:14:17.454+05:30	\N	f	f
cali_01K46AAXWNT6SR50D9BA16GHGZ	cart_01K46AAXHDHBT18YFJSZZDTR33	Medusa T-Shirt	M / White	https://medusa-public-images.s3.eu-west-1.amazonaws.com/tee-black-front.png	1	variant_01K465NX366HV3KMEAC710RB08	prod_01K465NX26VFWW6C9Y3GJN3K6V	Medusa T-Shirt	Reimagine the feeling of a classic T-shirt. With our cotton T-shirts, everyday essentials no longer have to be ordinary.	\N	\N	\N	t-shirt	SHIRT-M-WHITE	\N	M / White	\N	t	t	f	\N	\N	10	{"value": "10", "precision": 20}	{}	2025-09-03 04:26:34.709+05:30	2025-09-03 04:26:54.165+05:30	2025-09-03 04:26:54.164+05:30	\N	f	f
cali_01K46CC3KFQM0A776ZMMSYP60C	cart_01K46AR6866A7DP2JNHJTC0G5Y	Test	Default variant	\N	1	variant_01K46AVHD0MGCTKZ4NMHTMQT8Z	prod_01K46AVHBWZTYPJJMX5PFWQR1M	Test			\N	\N	test	\N	\N	Default variant	\N	t	f	f	\N	\N	500	{"value": "500", "precision": 20}	{}	2025-09-03 05:02:10.479+05:30	2025-09-03 05:02:10.479+05:30	\N	\N	f	f
cali_01K46AR6MA8AP6VXCAZQTG5K2K	cart_01K46AR6866A7DP2JNHJTC0G5Y	Medusa Shorts	S	https://medusa-public-images.s3.eu-west-1.amazonaws.com/shorts-vintage-front.png	1	variant_01K465NX3659TBXRDK2MZ3S3QJ	prod_01K465NX266PGFTQ8PFSGZS1R3	Medusa Shorts	Reimagine the feeling of classic shorts. With our cotton shorts, everyday essentials no longer have to be ordinary.	\N	\N	\N	shorts	SHORTS-S	\N	S	\N	t	t	f	\N	\N	500	{"value": "500", "precision": 20}	{}	2025-09-03 04:33:49.642+05:30	2025-09-03 05:02:13.15+05:30	2025-09-03 05:02:13.15+05:30	\N	f	f
\.


--
-- Data for Name: cart_line_item_adjustment; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cart_line_item_adjustment (id, description, promotion_id, code, amount, raw_amount, provider_id, metadata, created_at, updated_at, deleted_at, item_id, is_tax_inclusive) FROM stdin;
\.


--
-- Data for Name: cart_line_item_tax_line; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cart_line_item_tax_line (id, description, tax_rate_id, code, rate, provider_id, metadata, created_at, updated_at, deleted_at, item_id) FROM stdin;
\.


--
-- Data for Name: cart_payment_collection; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cart_payment_collection (cart_id, payment_collection_id, id, created_at, updated_at, deleted_at) FROM stdin;
cart_01K466AXHFNSF95BC7REXFZ8B0	pay_col_01K46A16VZNY85A3HR7P2TGF0T	capaycol_01K46A16WGF975PTCM6A5FEXZA	2025-09-03 04:21:16.240349+05:30	2025-09-03 04:21:16.240349+05:30	\N
\.


--
-- Data for Name: cart_promotion; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cart_promotion (cart_id, promotion_id, id, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: cart_shipping_method; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cart_shipping_method (id, cart_id, name, description, amount, raw_amount, is_tax_inclusive, shipping_option_id, data, metadata, created_at, updated_at, deleted_at) FROM stdin;
casm_01K46A12WMTEF0WW2GPAESHJ3N	cart_01K466AXHFNSF95BC7REXFZ8B0	Standard Shipping	\N	10	{"value": "10", "precision": 20}	f	so_01K465NX0W8FHES8P37CAFHZS3	{}	\N	2025-09-03 04:21:12.148+05:30	2025-09-03 04:21:12.148+05:30	\N
\.


--
-- Data for Name: cart_shipping_method_adjustment; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cart_shipping_method_adjustment (id, description, promotion_id, code, amount, raw_amount, provider_id, metadata, created_at, updated_at, deleted_at, shipping_method_id) FROM stdin;
\.


--
-- Data for Name: cart_shipping_method_tax_line; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cart_shipping_method_tax_line (id, description, tax_rate_id, code, rate, provider_id, metadata, created_at, updated_at, deleted_at, shipping_method_id) FROM stdin;
\.


--
-- Data for Name: credit_line; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.credit_line (id, cart_id, reference, reference_id, amount, raw_amount, metadata, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: currency; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.currency (code, symbol, symbol_native, decimal_digits, rounding, raw_rounding, name, created_at, updated_at, deleted_at) FROM stdin;
usd	$	$	2	0	{"value": "0", "precision": 20}	US Dollar	2025-09-03 03:05:07.415+05:30	2025-09-03 03:05:07.415+05:30	\N
cad	CA$	$	2	0	{"value": "0", "precision": 20}	Canadian Dollar	2025-09-03 03:05:07.416+05:30	2025-09-03 03:05:07.416+05:30	\N
eur	€	€	2	0	{"value": "0", "precision": 20}	Euro	2025-09-03 03:05:07.416+05:30	2025-09-03 03:05:07.416+05:30	\N
aed	AED	د.إ.‏	2	0	{"value": "0", "precision": 20}	United Arab Emirates Dirham	2025-09-03 03:05:07.416+05:30	2025-09-03 03:05:07.416+05:30	\N
afn	Af	؋	0	0	{"value": "0", "precision": 20}	Afghan Afghani	2025-09-03 03:05:07.416+05:30	2025-09-03 03:05:07.416+05:30	\N
all	ALL	Lek	0	0	{"value": "0", "precision": 20}	Albanian Lek	2025-09-03 03:05:07.416+05:30	2025-09-03 03:05:07.416+05:30	\N
amd	AMD	դր.	0	0	{"value": "0", "precision": 20}	Armenian Dram	2025-09-03 03:05:07.416+05:30	2025-09-03 03:05:07.416+05:30	\N
ars	AR$	$	2	0	{"value": "0", "precision": 20}	Argentine Peso	2025-09-03 03:05:07.416+05:30	2025-09-03 03:05:07.416+05:30	\N
aud	AU$	$	2	0	{"value": "0", "precision": 20}	Australian Dollar	2025-09-03 03:05:07.416+05:30	2025-09-03 03:05:07.416+05:30	\N
azn	man.	ман.	2	0	{"value": "0", "precision": 20}	Azerbaijani Manat	2025-09-03 03:05:07.416+05:30	2025-09-03 03:05:07.416+05:30	\N
bam	KM	KM	2	0	{"value": "0", "precision": 20}	Bosnia-Herzegovina Convertible Mark	2025-09-03 03:05:07.416+05:30	2025-09-03 03:05:07.416+05:30	\N
bdt	Tk	৳	2	0	{"value": "0", "precision": 20}	Bangladeshi Taka	2025-09-03 03:05:07.416+05:30	2025-09-03 03:05:07.416+05:30	\N
bgn	BGN	лв.	2	0	{"value": "0", "precision": 20}	Bulgarian Lev	2025-09-03 03:05:07.416+05:30	2025-09-03 03:05:07.416+05:30	\N
bhd	BD	د.ب.‏	3	0	{"value": "0", "precision": 20}	Bahraini Dinar	2025-09-03 03:05:07.416+05:30	2025-09-03 03:05:07.416+05:30	\N
bif	FBu	FBu	0	0	{"value": "0", "precision": 20}	Burundian Franc	2025-09-03 03:05:07.416+05:30	2025-09-03 03:05:07.416+05:30	\N
bnd	BN$	$	2	0	{"value": "0", "precision": 20}	Brunei Dollar	2025-09-03 03:05:07.416+05:30	2025-09-03 03:05:07.416+05:30	\N
bob	Bs	Bs	2	0	{"value": "0", "precision": 20}	Bolivian Boliviano	2025-09-03 03:05:07.416+05:30	2025-09-03 03:05:07.416+05:30	\N
brl	R$	R$	2	0	{"value": "0", "precision": 20}	Brazilian Real	2025-09-03 03:05:07.416+05:30	2025-09-03 03:05:07.416+05:30	\N
bwp	BWP	P	2	0	{"value": "0", "precision": 20}	Botswanan Pula	2025-09-03 03:05:07.416+05:30	2025-09-03 03:05:07.416+05:30	\N
byn	Br	руб.	2	0	{"value": "0", "precision": 20}	Belarusian Ruble	2025-09-03 03:05:07.416+05:30	2025-09-03 03:05:07.416+05:30	\N
bzd	BZ$	$	2	0	{"value": "0", "precision": 20}	Belize Dollar	2025-09-03 03:05:07.416+05:30	2025-09-03 03:05:07.416+05:30	\N
cdf	CDF	FrCD	2	0	{"value": "0", "precision": 20}	Congolese Franc	2025-09-03 03:05:07.416+05:30	2025-09-03 03:05:07.416+05:30	\N
chf	CHF	CHF	2	0.05	{"value": "0.05", "precision": 20}	Swiss Franc	2025-09-03 03:05:07.416+05:30	2025-09-03 03:05:07.416+05:30	\N
clp	CL$	$	0	0	{"value": "0", "precision": 20}	Chilean Peso	2025-09-03 03:05:07.416+05:30	2025-09-03 03:05:07.416+05:30	\N
cny	CN¥	CN¥	2	0	{"value": "0", "precision": 20}	Chinese Yuan	2025-09-03 03:05:07.416+05:30	2025-09-03 03:05:07.416+05:30	\N
cop	CO$	$	0	0	{"value": "0", "precision": 20}	Colombian Peso	2025-09-03 03:05:07.416+05:30	2025-09-03 03:05:07.416+05:30	\N
crc	₡	₡	0	0	{"value": "0", "precision": 20}	Costa Rican Colón	2025-09-03 03:05:07.416+05:30	2025-09-03 03:05:07.416+05:30	\N
cve	CV$	CV$	2	0	{"value": "0", "precision": 20}	Cape Verdean Escudo	2025-09-03 03:05:07.416+05:30	2025-09-03 03:05:07.416+05:30	\N
czk	Kč	Kč	2	0	{"value": "0", "precision": 20}	Czech Republic Koruna	2025-09-03 03:05:07.416+05:30	2025-09-03 03:05:07.416+05:30	\N
djf	Fdj	Fdj	0	0	{"value": "0", "precision": 20}	Djiboutian Franc	2025-09-03 03:05:07.416+05:30	2025-09-03 03:05:07.416+05:30	\N
dkk	Dkr	kr	2	0	{"value": "0", "precision": 20}	Danish Krone	2025-09-03 03:05:07.416+05:30	2025-09-03 03:05:07.416+05:30	\N
dop	RD$	RD$	2	0	{"value": "0", "precision": 20}	Dominican Peso	2025-09-03 03:05:07.416+05:30	2025-09-03 03:05:07.416+05:30	\N
dzd	DA	د.ج.‏	2	0	{"value": "0", "precision": 20}	Algerian Dinar	2025-09-03 03:05:07.416+05:30	2025-09-03 03:05:07.416+05:30	\N
eek	Ekr	kr	2	0	{"value": "0", "precision": 20}	Estonian Kroon	2025-09-03 03:05:07.416+05:30	2025-09-03 03:05:07.416+05:30	\N
egp	EGP	ج.م.‏	2	0	{"value": "0", "precision": 20}	Egyptian Pound	2025-09-03 03:05:07.416+05:30	2025-09-03 03:05:07.416+05:30	\N
ern	Nfk	Nfk	2	0	{"value": "0", "precision": 20}	Eritrean Nakfa	2025-09-03 03:05:07.416+05:30	2025-09-03 03:05:07.416+05:30	\N
etb	Br	Br	2	0	{"value": "0", "precision": 20}	Ethiopian Birr	2025-09-03 03:05:07.416+05:30	2025-09-03 03:05:07.416+05:30	\N
gbp	£	£	2	0	{"value": "0", "precision": 20}	British Pound Sterling	2025-09-03 03:05:07.416+05:30	2025-09-03 03:05:07.416+05:30	\N
gel	GEL	GEL	2	0	{"value": "0", "precision": 20}	Georgian Lari	2025-09-03 03:05:07.416+05:30	2025-09-03 03:05:07.416+05:30	\N
ghs	GH₵	GH₵	2	0	{"value": "0", "precision": 20}	Ghanaian Cedi	2025-09-03 03:05:07.416+05:30	2025-09-03 03:05:07.416+05:30	\N
gnf	FG	FG	0	0	{"value": "0", "precision": 20}	Guinean Franc	2025-09-03 03:05:07.416+05:30	2025-09-03 03:05:07.416+05:30	\N
gtq	GTQ	Q	2	0	{"value": "0", "precision": 20}	Guatemalan Quetzal	2025-09-03 03:05:07.416+05:30	2025-09-03 03:05:07.416+05:30	\N
hkd	HK$	$	2	0	{"value": "0", "precision": 20}	Hong Kong Dollar	2025-09-03 03:05:07.416+05:30	2025-09-03 03:05:07.416+05:30	\N
hnl	HNL	L	2	0	{"value": "0", "precision": 20}	Honduran Lempira	2025-09-03 03:05:07.416+05:30	2025-09-03 03:05:07.416+05:30	\N
hrk	kn	kn	2	0	{"value": "0", "precision": 20}	Croatian Kuna	2025-09-03 03:05:07.416+05:30	2025-09-03 03:05:07.416+05:30	\N
huf	Ft	Ft	0	0	{"value": "0", "precision": 20}	Hungarian Forint	2025-09-03 03:05:07.416+05:30	2025-09-03 03:05:07.416+05:30	\N
idr	Rp	Rp	0	0	{"value": "0", "precision": 20}	Indonesian Rupiah	2025-09-03 03:05:07.416+05:30	2025-09-03 03:05:07.416+05:30	\N
ils	₪	₪	2	0	{"value": "0", "precision": 20}	Israeli New Sheqel	2025-09-03 03:05:07.416+05:30	2025-09-03 03:05:07.416+05:30	\N
inr	Rs	₹	2	0	{"value": "0", "precision": 20}	Indian Rupee	2025-09-03 03:05:07.416+05:30	2025-09-03 03:05:07.416+05:30	\N
iqd	IQD	د.ع.‏	0	0	{"value": "0", "precision": 20}	Iraqi Dinar	2025-09-03 03:05:07.416+05:30	2025-09-03 03:05:07.416+05:30	\N
irr	IRR	﷼	0	0	{"value": "0", "precision": 20}	Iranian Rial	2025-09-03 03:05:07.416+05:30	2025-09-03 03:05:07.416+05:30	\N
isk	Ikr	kr	0	0	{"value": "0", "precision": 20}	Icelandic Króna	2025-09-03 03:05:07.416+05:30	2025-09-03 03:05:07.416+05:30	\N
jmd	J$	$	2	0	{"value": "0", "precision": 20}	Jamaican Dollar	2025-09-03 03:05:07.416+05:30	2025-09-03 03:05:07.416+05:30	\N
jod	JD	د.أ.‏	3	0	{"value": "0", "precision": 20}	Jordanian Dinar	2025-09-03 03:05:07.416+05:30	2025-09-03 03:05:07.416+05:30	\N
jpy	¥	￥	0	0	{"value": "0", "precision": 20}	Japanese Yen	2025-09-03 03:05:07.416+05:30	2025-09-03 03:05:07.416+05:30	\N
kes	Ksh	Ksh	2	0	{"value": "0", "precision": 20}	Kenyan Shilling	2025-09-03 03:05:07.416+05:30	2025-09-03 03:05:07.416+05:30	\N
khr	KHR	៛	2	0	{"value": "0", "precision": 20}	Cambodian Riel	2025-09-03 03:05:07.416+05:30	2025-09-03 03:05:07.416+05:30	\N
kmf	CF	FC	0	0	{"value": "0", "precision": 20}	Comorian Franc	2025-09-03 03:05:07.416+05:30	2025-09-03 03:05:07.416+05:30	\N
krw	₩	₩	0	0	{"value": "0", "precision": 20}	South Korean Won	2025-09-03 03:05:07.416+05:30	2025-09-03 03:05:07.416+05:30	\N
kwd	KD	د.ك.‏	3	0	{"value": "0", "precision": 20}	Kuwaiti Dinar	2025-09-03 03:05:07.416+05:30	2025-09-03 03:05:07.416+05:30	\N
kzt	KZT	тңг.	2	0	{"value": "0", "precision": 20}	Kazakhstani Tenge	2025-09-03 03:05:07.417+05:30	2025-09-03 03:05:07.417+05:30	\N
lbp	LB£	ل.ل.‏	0	0	{"value": "0", "precision": 20}	Lebanese Pound	2025-09-03 03:05:07.417+05:30	2025-09-03 03:05:07.417+05:30	\N
lkr	SLRs	SL Re	2	0	{"value": "0", "precision": 20}	Sri Lankan Rupee	2025-09-03 03:05:07.417+05:30	2025-09-03 03:05:07.417+05:30	\N
ltl	Lt	Lt	2	0	{"value": "0", "precision": 20}	Lithuanian Litas	2025-09-03 03:05:07.417+05:30	2025-09-03 03:05:07.417+05:30	\N
lvl	Ls	Ls	2	0	{"value": "0", "precision": 20}	Latvian Lats	2025-09-03 03:05:07.417+05:30	2025-09-03 03:05:07.417+05:30	\N
lyd	LD	د.ل.‏	3	0	{"value": "0", "precision": 20}	Libyan Dinar	2025-09-03 03:05:07.417+05:30	2025-09-03 03:05:07.417+05:30	\N
mad	MAD	د.م.‏	2	0	{"value": "0", "precision": 20}	Moroccan Dirham	2025-09-03 03:05:07.417+05:30	2025-09-03 03:05:07.417+05:30	\N
mdl	MDL	MDL	2	0	{"value": "0", "precision": 20}	Moldovan Leu	2025-09-03 03:05:07.417+05:30	2025-09-03 03:05:07.417+05:30	\N
mga	MGA	MGA	0	0	{"value": "0", "precision": 20}	Malagasy Ariary	2025-09-03 03:05:07.417+05:30	2025-09-03 03:05:07.417+05:30	\N
mkd	MKD	MKD	2	0	{"value": "0", "precision": 20}	Macedonian Denar	2025-09-03 03:05:07.417+05:30	2025-09-03 03:05:07.417+05:30	\N
mmk	MMK	K	0	0	{"value": "0", "precision": 20}	Myanma Kyat	2025-09-03 03:05:07.417+05:30	2025-09-03 03:05:07.417+05:30	\N
mnt	MNT	₮	0	0	{"value": "0", "precision": 20}	Mongolian Tugrig	2025-09-03 03:05:07.417+05:30	2025-09-03 03:05:07.417+05:30	\N
mop	MOP$	MOP$	2	0	{"value": "0", "precision": 20}	Macanese Pataca	2025-09-03 03:05:07.417+05:30	2025-09-03 03:05:07.417+05:30	\N
mur	MURs	MURs	0	0	{"value": "0", "precision": 20}	Mauritian Rupee	2025-09-03 03:05:07.417+05:30	2025-09-03 03:05:07.417+05:30	\N
mwk	K	K	2	0	{"value": "0", "precision": 20}	Malawian Kwacha	2025-09-03 03:05:07.417+05:30	2025-09-03 03:05:07.417+05:30	\N
mxn	MX$	$	2	0	{"value": "0", "precision": 20}	Mexican Peso	2025-09-03 03:05:07.417+05:30	2025-09-03 03:05:07.417+05:30	\N
myr	RM	RM	2	0	{"value": "0", "precision": 20}	Malaysian Ringgit	2025-09-03 03:05:07.417+05:30	2025-09-03 03:05:07.417+05:30	\N
mzn	MTn	MTn	2	0	{"value": "0", "precision": 20}	Mozambican Metical	2025-09-03 03:05:07.417+05:30	2025-09-03 03:05:07.417+05:30	\N
nad	N$	N$	2	0	{"value": "0", "precision": 20}	Namibian Dollar	2025-09-03 03:05:07.417+05:30	2025-09-03 03:05:07.417+05:30	\N
ngn	₦	₦	2	0	{"value": "0", "precision": 20}	Nigerian Naira	2025-09-03 03:05:07.417+05:30	2025-09-03 03:05:07.417+05:30	\N
nio	C$	C$	2	0	{"value": "0", "precision": 20}	Nicaraguan Córdoba	2025-09-03 03:05:07.417+05:30	2025-09-03 03:05:07.417+05:30	\N
nok	Nkr	kr	2	0	{"value": "0", "precision": 20}	Norwegian Krone	2025-09-03 03:05:07.417+05:30	2025-09-03 03:05:07.417+05:30	\N
npr	NPRs	नेरू	2	0	{"value": "0", "precision": 20}	Nepalese Rupee	2025-09-03 03:05:07.417+05:30	2025-09-03 03:05:07.417+05:30	\N
nzd	NZ$	$	2	0	{"value": "0", "precision": 20}	New Zealand Dollar	2025-09-03 03:05:07.417+05:30	2025-09-03 03:05:07.417+05:30	\N
omr	OMR	ر.ع.‏	3	0	{"value": "0", "precision": 20}	Omani Rial	2025-09-03 03:05:07.417+05:30	2025-09-03 03:05:07.417+05:30	\N
pab	B/.	B/.	2	0	{"value": "0", "precision": 20}	Panamanian Balboa	2025-09-03 03:05:07.417+05:30	2025-09-03 03:05:07.417+05:30	\N
pen	S/.	S/.	2	0	{"value": "0", "precision": 20}	Peruvian Nuevo Sol	2025-09-03 03:05:07.417+05:30	2025-09-03 03:05:07.417+05:30	\N
php	₱	₱	2	0	{"value": "0", "precision": 20}	Philippine Peso	2025-09-03 03:05:07.417+05:30	2025-09-03 03:05:07.417+05:30	\N
pkr	PKRs	₨	0	0	{"value": "0", "precision": 20}	Pakistani Rupee	2025-09-03 03:05:07.417+05:30	2025-09-03 03:05:07.417+05:30	\N
pln	zł	zł	2	0	{"value": "0", "precision": 20}	Polish Zloty	2025-09-03 03:05:07.417+05:30	2025-09-03 03:05:07.417+05:30	\N
pyg	₲	₲	0	0	{"value": "0", "precision": 20}	Paraguayan Guarani	2025-09-03 03:05:07.417+05:30	2025-09-03 03:05:07.417+05:30	\N
qar	QR	ر.ق.‏	2	0	{"value": "0", "precision": 20}	Qatari Rial	2025-09-03 03:05:07.417+05:30	2025-09-03 03:05:07.417+05:30	\N
ron	RON	RON	2	0	{"value": "0", "precision": 20}	Romanian Leu	2025-09-03 03:05:07.417+05:30	2025-09-03 03:05:07.417+05:30	\N
rsd	din.	дин.	0	0	{"value": "0", "precision": 20}	Serbian Dinar	2025-09-03 03:05:07.417+05:30	2025-09-03 03:05:07.417+05:30	\N
rub	RUB	₽.	2	0	{"value": "0", "precision": 20}	Russian Ruble	2025-09-03 03:05:07.417+05:30	2025-09-03 03:05:07.417+05:30	\N
rwf	RWF	FR	0	0	{"value": "0", "precision": 20}	Rwandan Franc	2025-09-03 03:05:07.417+05:30	2025-09-03 03:05:07.417+05:30	\N
sar	SR	ر.س.‏	2	0	{"value": "0", "precision": 20}	Saudi Riyal	2025-09-03 03:05:07.417+05:30	2025-09-03 03:05:07.417+05:30	\N
sdg	SDG	SDG	2	0	{"value": "0", "precision": 20}	Sudanese Pound	2025-09-03 03:05:07.417+05:30	2025-09-03 03:05:07.417+05:30	\N
sek	Skr	kr	2	0	{"value": "0", "precision": 20}	Swedish Krona	2025-09-03 03:05:07.417+05:30	2025-09-03 03:05:07.417+05:30	\N
sgd	S$	$	2	0	{"value": "0", "precision": 20}	Singapore Dollar	2025-09-03 03:05:07.417+05:30	2025-09-03 03:05:07.417+05:30	\N
sos	Ssh	Ssh	0	0	{"value": "0", "precision": 20}	Somali Shilling	2025-09-03 03:05:07.417+05:30	2025-09-03 03:05:07.417+05:30	\N
syp	SY£	ل.س.‏	0	0	{"value": "0", "precision": 20}	Syrian Pound	2025-09-03 03:05:07.417+05:30	2025-09-03 03:05:07.417+05:30	\N
thb	฿	฿	2	0	{"value": "0", "precision": 20}	Thai Baht	2025-09-03 03:05:07.417+05:30	2025-09-03 03:05:07.417+05:30	\N
tnd	DT	د.ت.‏	3	0	{"value": "0", "precision": 20}	Tunisian Dinar	2025-09-03 03:05:07.417+05:30	2025-09-03 03:05:07.417+05:30	\N
top	T$	T$	2	0	{"value": "0", "precision": 20}	Tongan Paʻanga	2025-09-03 03:05:07.417+05:30	2025-09-03 03:05:07.417+05:30	\N
try	₺	₺	2	0	{"value": "0", "precision": 20}	Turkish Lira	2025-09-03 03:05:07.417+05:30	2025-09-03 03:05:07.417+05:30	\N
ttd	TT$	$	2	0	{"value": "0", "precision": 20}	Trinidad and Tobago Dollar	2025-09-03 03:05:07.417+05:30	2025-09-03 03:05:07.417+05:30	\N
twd	NT$	NT$	2	0	{"value": "0", "precision": 20}	New Taiwan Dollar	2025-09-03 03:05:07.417+05:30	2025-09-03 03:05:07.417+05:30	\N
tzs	TSh	TSh	0	0	{"value": "0", "precision": 20}	Tanzanian Shilling	2025-09-03 03:05:07.417+05:30	2025-09-03 03:05:07.417+05:30	\N
uah	₴	₴	2	0	{"value": "0", "precision": 20}	Ukrainian Hryvnia	2025-09-03 03:05:07.417+05:30	2025-09-03 03:05:07.417+05:30	\N
ugx	USh	USh	0	0	{"value": "0", "precision": 20}	Ugandan Shilling	2025-09-03 03:05:07.417+05:30	2025-09-03 03:05:07.417+05:30	\N
uyu	$U	$	2	0	{"value": "0", "precision": 20}	Uruguayan Peso	2025-09-03 03:05:07.417+05:30	2025-09-03 03:05:07.417+05:30	\N
uzs	UZS	UZS	0	0	{"value": "0", "precision": 20}	Uzbekistan Som	2025-09-03 03:05:07.417+05:30	2025-09-03 03:05:07.417+05:30	\N
vef	Bs.F.	Bs.F.	2	0	{"value": "0", "precision": 20}	Venezuelan Bolívar	2025-09-03 03:05:07.417+05:30	2025-09-03 03:05:07.417+05:30	\N
vnd	₫	₫	0	0	{"value": "0", "precision": 20}	Vietnamese Dong	2025-09-03 03:05:07.417+05:30	2025-09-03 03:05:07.417+05:30	\N
xaf	FCFA	FCFA	0	0	{"value": "0", "precision": 20}	CFA Franc BEAC	2025-09-03 03:05:07.417+05:30	2025-09-03 03:05:07.417+05:30	\N
xof	CFA	CFA	0	0	{"value": "0", "precision": 20}	CFA Franc BCEAO	2025-09-03 03:05:07.417+05:30	2025-09-03 03:05:07.417+05:30	\N
xpf	₣	₣	0	0	{"value": "0", "precision": 20}	CFP Franc	2025-09-03 03:05:07.417+05:30	2025-09-03 03:05:07.417+05:30	\N
yer	YR	ر.ي.‏	0	0	{"value": "0", "precision": 20}	Yemeni Rial	2025-09-03 03:05:07.417+05:30	2025-09-03 03:05:07.417+05:30	\N
zar	R	R	2	0	{"value": "0", "precision": 20}	South African Rand	2025-09-03 03:05:07.417+05:30	2025-09-03 03:05:07.417+05:30	\N
zmk	ZK	ZK	0	0	{"value": "0", "precision": 20}	Zambian Kwacha	2025-09-03 03:05:07.417+05:30	2025-09-03 03:05:07.417+05:30	\N
zwl	ZWL$	ZWL$	0	0	{"value": "0", "precision": 20}	Zimbabwean Dollar	2025-09-03 03:05:07.417+05:30	2025-09-03 03:05:07.417+05:30	\N
\.


--
-- Data for Name: customer; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.customer (id, company_name, first_name, last_name, email, phone, has_account, metadata, created_at, updated_at, deleted_at, created_by) FROM stdin;
cus_01K46A0ZPRWKCSMQAW51DY0W8R	\N	\N	\N	mk@mk.com	\N	f	\N	2025-09-03 04:21:08.888+05:30	2025-09-03 04:21:08.888+05:30	\N	\N
cus_01K46A3BBP2PYVPB81ECAQ2CVM	\N	Mukul	Yadav	mk24x7@gmail.com	+448005251034	t	\N	2025-09-03 04:22:26.358+05:30	2025-09-03 04:22:26.358+05:30	\N	\N
\.


--
-- Data for Name: customer_account_holder; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.customer_account_holder (customer_id, account_holder_id, id, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: customer_address; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.customer_address (id, customer_id, address_name, is_default_shipping, is_default_billing, company, first_name, last_name, address_1, address_2, city, country_code, province, postal_code, phone, metadata, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: customer_group; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.customer_group (id, name, metadata, created_by, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: customer_group_customer; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.customer_group_customer (id, customer_id, customer_group_id, metadata, created_at, updated_at, created_by, deleted_at) FROM stdin;
\.


--
-- Data for Name: fulfillment; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.fulfillment (id, location_id, packed_at, shipped_at, delivered_at, canceled_at, data, provider_id, shipping_option_id, metadata, delivery_address_id, created_at, updated_at, deleted_at, marked_shipped_by, created_by, requires_shipping) FROM stdin;
ful_01K46C5DDKVJY90P99FVD3GDK2	sloc_01K465NX02PRA37GR065XPNVC1	2025-09-03 04:58:31.141+05:30	2025-09-03 04:58:36.071+05:30	2025-09-03 04:58:38.342+05:30	\N	{}	manual_manual	so_01K465NX0W8FHES8P37CAFHZS3	\N	fuladdr_01K46C5DDKHH45YRZ4MBTZYJWW	2025-09-03 04:58:31.156+05:30	2025-09-03 04:58:38.36+05:30	\N	\N	\N	t
\.


--
-- Data for Name: fulfillment_address; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.fulfillment_address (id, company, first_name, last_name, address_1, address_2, city, country_code, province, postal_code, phone, metadata, created_at, updated_at, deleted_at) FROM stdin;
fuladdr_01K46C5DDKHH45YRZ4MBTZYJWW		test	test	test		varanasi	it	up	221002		\N	2025-09-03 04:21:08.95+05:30	2025-09-03 04:21:08.95+05:30	\N
\.


--
-- Data for Name: fulfillment_item; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.fulfillment_item (id, title, sku, barcode, quantity, raw_quantity, line_item_id, inventory_item_id, fulfillment_id, created_at, updated_at, deleted_at) FROM stdin;
fulit_01K46C5DDJ5HMHPJF51JS5R4DW	M / Black	SHIRT-M-BLACK		1	{"value": "1", "precision": 20}	ordli_01K46A1CNQC8HHYQH4KJ54AGP4	iitem_01K465NX3KN80Z3BCCYJFH27BP	ful_01K46C5DDKVJY90P99FVD3GDK2	2025-09-03 04:58:31.156+05:30	2025-09-03 04:58:31.156+05:30	\N
\.


--
-- Data for Name: fulfillment_label; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.fulfillment_label (id, tracking_number, tracking_url, label_url, fulfillment_id, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: fulfillment_provider; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.fulfillment_provider (id, is_enabled, created_at, updated_at, deleted_at) FROM stdin;
manual_manual	t	2025-09-03 03:05:07.456+05:30	2025-09-03 03:05:07.456+05:30	\N
\.


--
-- Data for Name: fulfillment_set; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.fulfillment_set (id, name, type, metadata, created_at, updated_at, deleted_at) FROM stdin;
fuset_01K465NX0BS3XBXW4G9VJ79T0Z	European Warehouse delivery	shipping	\N	2025-09-03 03:05:11.371+05:30	2025-09-03 03:05:11.371+05:30	\N
\.


--
-- Data for Name: geo_zone; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.geo_zone (id, type, country_code, province_code, city, service_zone_id, postal_expression, metadata, created_at, updated_at, deleted_at) FROM stdin;
fgz_01K465NX0A0JH64MH5NZNAD4NZ	country	gb	\N	\N	serzo_01K465NX0B8X83QPDS4ZNJX86S	\N	\N	2025-09-03 03:05:11.371+05:30	2025-09-03 03:05:11.371+05:30	\N
fgz_01K465NX0A1JSCCX42NEES6DX8	country	de	\N	\N	serzo_01K465NX0B8X83QPDS4ZNJX86S	\N	\N	2025-09-03 03:05:11.371+05:30	2025-09-03 03:05:11.371+05:30	\N
fgz_01K465NX0AZBEWT7R6Y02KD1V2	country	dk	\N	\N	serzo_01K465NX0B8X83QPDS4ZNJX86S	\N	\N	2025-09-03 03:05:11.371+05:30	2025-09-03 03:05:11.371+05:30	\N
fgz_01K465NX0B3YRF21SX0J3TDTKJ	country	se	\N	\N	serzo_01K465NX0B8X83QPDS4ZNJX86S	\N	\N	2025-09-03 03:05:11.371+05:30	2025-09-03 03:05:11.371+05:30	\N
fgz_01K465NX0BAKW3MR8ZCXHBWCWM	country	fr	\N	\N	serzo_01K465NX0B8X83QPDS4ZNJX86S	\N	\N	2025-09-03 03:05:11.371+05:30	2025-09-03 03:05:11.371+05:30	\N
fgz_01K465NX0B4DMYHMB9CEGB3YVF	country	es	\N	\N	serzo_01K465NX0B8X83QPDS4ZNJX86S	\N	\N	2025-09-03 03:05:11.371+05:30	2025-09-03 03:05:11.371+05:30	\N
fgz_01K465NX0B28PCQXYB64QD47ER	country	it	\N	\N	serzo_01K465NX0B8X83QPDS4ZNJX86S	\N	\N	2025-09-03 03:05:11.371+05:30	2025-09-03 03:05:11.371+05:30	\N
\.


--
-- Data for Name: image; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.image (id, url, metadata, created_at, updated_at, deleted_at, rank, product_id) FROM stdin;
img_01K465NX28WY91QTZGWY6EGTY8	https://medusa-public-images.s3.eu-west-1.amazonaws.com/shorts-vintage-front.png	\N	2025-09-03 03:05:11.433+05:30	2025-09-03 04:57:23.385+05:30	2025-09-03 04:57:23.378+05:30	0	prod_01K465NX266PGFTQ8PFSGZS1R3
img_01K465NX28CE9V3MCYPPBBHCP2	https://medusa-public-images.s3.eu-west-1.amazonaws.com/shorts-vintage-back.png	\N	2025-09-03 03:05:11.433+05:30	2025-09-03 04:57:23.385+05:30	2025-09-03 04:57:23.378+05:30	1	prod_01K465NX266PGFTQ8PFSGZS1R3
img_01K465NX277JRZD3ABM41BQJEK	https://medusa-public-images.s3.eu-west-1.amazonaws.com/sweatshirt-vintage-front.png	\N	2025-09-03 03:05:11.433+05:30	2025-09-03 04:57:26+05:30	2025-09-03 04:57:25.988+05:30	0	prod_01K465NX26NHGQZJXTREXN0BT0
img_01K465NX2791Q32E0SEDG3W6XG	https://medusa-public-images.s3.eu-west-1.amazonaws.com/sweatshirt-vintage-back.png	\N	2025-09-03 03:05:11.433+05:30	2025-09-03 04:57:26+05:30	2025-09-03 04:57:25.988+05:30	1	prod_01K465NX26NHGQZJXTREXN0BT0
img_01K465NX28YKS1JTMJF0D9ZXY4	https://medusa-public-images.s3.eu-west-1.amazonaws.com/sweatpants-gray-front.png	\N	2025-09-03 03:05:11.433+05:30	2025-09-03 04:57:28.785+05:30	2025-09-03 04:57:28.777+05:30	0	prod_01K465NX26PX533H2S8NXXM0JE
img_01K465NX2896MW3FZGQMT5GK41	https://medusa-public-images.s3.eu-west-1.amazonaws.com/sweatpants-gray-back.png	\N	2025-09-03 03:05:11.433+05:30	2025-09-03 04:57:28.785+05:30	2025-09-03 04:57:28.777+05:30	1	prod_01K465NX26PX533H2S8NXXM0JE
img_01K465NX27RCKHQJ03YX12MXSH	https://medusa-public-images.s3.eu-west-1.amazonaws.com/tee-black-front.png	\N	2025-09-03 03:05:11.433+05:30	2025-09-03 04:58:46.294+05:30	2025-09-03 04:58:46.282+05:30	0	prod_01K465NX26VFWW6C9Y3GJN3K6V
img_01K465NX27442ZN8QE4JQ2JPEY	https://medusa-public-images.s3.eu-west-1.amazonaws.com/tee-black-back.png	\N	2025-09-03 03:05:11.433+05:30	2025-09-03 04:58:46.294+05:30	2025-09-03 04:58:46.282+05:30	1	prod_01K465NX26VFWW6C9Y3GJN3K6V
img_01K465NX27J17912XK6FXN52GP	https://medusa-public-images.s3.eu-west-1.amazonaws.com/tee-white-front.png	\N	2025-09-03 03:05:11.433+05:30	2025-09-03 04:58:46.294+05:30	2025-09-03 04:58:46.282+05:30	2	prod_01K465NX26VFWW6C9Y3GJN3K6V
img_01K465NX277M0K1BV2MVJWJGG7	https://medusa-public-images.s3.eu-west-1.amazonaws.com/tee-white-back.png	\N	2025-09-03 03:05:11.433+05:30	2025-09-03 04:58:46.295+05:30	2025-09-03 04:58:46.282+05:30	3	prod_01K465NX26VFWW6C9Y3GJN3K6V
\.


--
-- Data for Name: inventory_item; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.inventory_item (id, created_at, updated_at, deleted_at, sku, origin_country, hs_code, mid_code, material, weight, length, height, width, requires_shipping, description, title, thumbnail, metadata) FROM stdin;
iitem_01K465NX3M4RT8CAEXJ1QKZ7Z2	2025-09-03 03:05:11.476+05:30	2025-09-03 04:57:23.334+05:30	2025-09-03 04:57:23.332+05:30	SHORTS-L	\N	\N	\N	\N	\N	\N	\N	\N	t	L	L	\N	\N
iitem_01K465NX3MSRWD47J6GAMEEE4V	2025-09-03 03:05:11.476+05:30	2025-09-03 04:57:23.346+05:30	2025-09-03 04:57:23.332+05:30	SHORTS-M	\N	\N	\N	\N	\N	\N	\N	\N	t	M	M	\N	\N
iitem_01K465NX3KX2Y3P7ZBKZR2J82M	2025-09-03 03:05:11.476+05:30	2025-09-03 04:57:23.352+05:30	2025-09-03 04:57:23.332+05:30	SHORTS-S	\N	\N	\N	\N	\N	\N	\N	\N	t	S	S	\N	\N
iitem_01K465NX3MXW0YJG2CMDP73AN7	2025-09-03 03:05:11.476+05:30	2025-09-03 04:57:23.355+05:30	2025-09-03 04:57:23.332+05:30	SHORTS-XL	\N	\N	\N	\N	\N	\N	\N	\N	t	XL	XL	\N	\N
iitem_01K465NX3K92G4FED4ENTQQBV0	2025-09-03 03:05:11.476+05:30	2025-09-03 04:57:25.957+05:30	2025-09-03 04:57:25.957+05:30	SWEATSHIRT-L	\N	\N	\N	\N	\N	\N	\N	\N	t	L	L	\N	\N
iitem_01K465NX3KZQAGR8TJD8KM2MJ6	2025-09-03 03:05:11.476+05:30	2025-09-03 04:57:25.961+05:30	2025-09-03 04:57:25.957+05:30	SWEATSHIRT-M	\N	\N	\N	\N	\N	\N	\N	\N	t	M	M	\N	\N
iitem_01K465NX3K3V01QEXHAZA3XRPF	2025-09-03 03:05:11.476+05:30	2025-09-03 04:57:25.966+05:30	2025-09-03 04:57:25.957+05:30	SWEATSHIRT-S	\N	\N	\N	\N	\N	\N	\N	\N	t	S	S	\N	\N
iitem_01K465NX3KGGW9PBGMA6QZ8639	2025-09-03 03:05:11.476+05:30	2025-09-03 04:57:25.971+05:30	2025-09-03 04:57:25.957+05:30	SWEATSHIRT-XL	\N	\N	\N	\N	\N	\N	\N	\N	t	XL	XL	\N	\N
iitem_01K465NX3K0TTEHQD5MPKTN77K	2025-09-03 03:05:11.476+05:30	2025-09-03 04:57:28.751+05:30	2025-09-03 04:57:28.751+05:30	SWEATPANTS-L	\N	\N	\N	\N	\N	\N	\N	\N	t	L	L	\N	\N
iitem_01K465NX3KDM01XEXK1CDXT1S1	2025-09-03 03:05:11.476+05:30	2025-09-03 04:57:28.756+05:30	2025-09-03 04:57:28.751+05:30	SWEATPANTS-M	\N	\N	\N	\N	\N	\N	\N	\N	t	M	M	\N	\N
iitem_01K465NX3K3JE3ZGA8N1JEPAN4	2025-09-03 03:05:11.476+05:30	2025-09-03 04:57:28.759+05:30	2025-09-03 04:57:28.751+05:30	SWEATPANTS-S	\N	\N	\N	\N	\N	\N	\N	\N	t	S	S	\N	\N
iitem_01K465NX3KFA9HZKP6DTS54DVM	2025-09-03 03:05:11.476+05:30	2025-09-03 04:57:28.762+05:30	2025-09-03 04:57:28.751+05:30	SWEATPANTS-XL	\N	\N	\N	\N	\N	\N	\N	\N	t	XL	XL	\N	\N
iitem_01K465NX3K5H8B3VZ9R15WX93C	2025-09-03 03:05:11.476+05:30	2025-09-03 04:58:46.218+05:30	2025-09-03 04:58:46.218+05:30	SHIRT-L-BLACK	\N	\N	\N	\N	\N	\N	\N	\N	t	L / Black	L / Black	\N	\N
iitem_01K465NX3KZKX8H25Q1EWVPZC6	2025-09-03 03:05:11.476+05:30	2025-09-03 04:58:46.224+05:30	2025-09-03 04:58:46.218+05:30	SHIRT-L-WHITE	\N	\N	\N	\N	\N	\N	\N	\N	t	L / White	L / White	\N	\N
iitem_01K465NX3KN80Z3BCCYJFH27BP	2025-09-03 03:05:11.476+05:30	2025-09-03 04:58:46.227+05:30	2025-09-03 04:58:46.218+05:30	SHIRT-M-BLACK	\N	\N	\N	\N	\N	\N	\N	\N	t	M / Black	M / Black	\N	\N
iitem_01K465NX3KPDDV32DQZK5TAE5M	2025-09-03 03:05:11.476+05:30	2025-09-03 04:58:46.231+05:30	2025-09-03 04:58:46.218+05:30	SHIRT-M-WHITE	\N	\N	\N	\N	\N	\N	\N	\N	t	M / White	M / White	\N	\N
iitem_01K465NX3KBWKB951V07M21BEF	2025-09-03 03:05:11.476+05:30	2025-09-03 04:58:46.235+05:30	2025-09-03 04:58:46.218+05:30	SHIRT-S-BLACK	\N	\N	\N	\N	\N	\N	\N	\N	t	S / Black	S / Black	\N	\N
iitem_01K465NX3KKGH4WP9ZWEVFEP0Z	2025-09-03 03:05:11.476+05:30	2025-09-03 04:58:46.238+05:30	2025-09-03 04:58:46.218+05:30	SHIRT-S-WHITE	\N	\N	\N	\N	\N	\N	\N	\N	t	S / White	S / White	\N	\N
iitem_01K465NX3K9RWBBSYGQ8SGS1SD	2025-09-03 03:05:11.476+05:30	2025-09-03 04:58:46.241+05:30	2025-09-03 04:58:46.218+05:30	SHIRT-XL-BLACK	\N	\N	\N	\N	\N	\N	\N	\N	t	XL / Black	XL / Black	\N	\N
iitem_01K465NX3KJHWDDPGH9ZVGAYQX	2025-09-03 03:05:11.476+05:30	2025-09-03 04:58:46.245+05:30	2025-09-03 04:58:46.218+05:30	SHIRT-XL-WHITE	\N	\N	\N	\N	\N	\N	\N	\N	t	XL / White	XL / White	\N	\N
\.


--
-- Data for Name: inventory_level; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.inventory_level (id, created_at, updated_at, deleted_at, inventory_item_id, location_id, stocked_quantity, reserved_quantity, incoming_quantity, metadata, raw_stocked_quantity, raw_reserved_quantity, raw_incoming_quantity) FROM stdin;
ilev_01K465NX5ADCNTJ29Y6NC9KP0J	2025-09-03 03:05:11.531+05:30	2025-09-03 04:58:46.231+05:30	2025-09-03 04:58:46.218+05:30	iitem_01K465NX3KN80Z3BCCYJFH27BP	sloc_01K465NX02PRA37GR065XPNVC1	999999	0	0	\N	{"value": "999999", "precision": 20}	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}
ilev_01K465NX5B8PKWX60Z13KYR6DW	2025-09-03 03:05:11.531+05:30	2025-09-03 04:57:23.346+05:30	2025-09-03 04:57:23.332+05:30	iitem_01K465NX3M4RT8CAEXJ1QKZ7Z2	sloc_01K465NX02PRA37GR065XPNVC1	1000000	0	0	\N	{"value": "1000000", "precision": 20}	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}
ilev_01K465NX5BVC4N7Q0AXRPHJ808	2025-09-03 03:05:11.531+05:30	2025-09-03 04:57:23.351+05:30	2025-09-03 04:57:23.332+05:30	iitem_01K465NX3MSRWD47J6GAMEEE4V	sloc_01K465NX02PRA37GR065XPNVC1	1000000	0	0	\N	{"value": "1000000", "precision": 20}	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}
ilev_01K465NX5ANK7SNKZ36AP1B0ZD	2025-09-03 03:05:11.531+05:30	2025-09-03 04:57:23.355+05:30	2025-09-03 04:57:23.332+05:30	iitem_01K465NX3KX2Y3P7ZBKZR2J82M	sloc_01K465NX02PRA37GR065XPNVC1	1000000	0	0	\N	{"value": "1000000", "precision": 20}	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}
ilev_01K465NX5BQ9HX2ACWGJWH4TK1	2025-09-03 03:05:11.531+05:30	2025-09-03 04:57:23.359+05:30	2025-09-03 04:57:23.332+05:30	iitem_01K465NX3MXW0YJG2CMDP73AN7	sloc_01K465NX02PRA37GR065XPNVC1	1000000	0	0	\N	{"value": "1000000", "precision": 20}	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}
ilev_01K465NX5A1JPD4VSYC88K7GDC	2025-09-03 03:05:11.531+05:30	2025-09-03 04:57:25.961+05:30	2025-09-03 04:57:25.957+05:30	iitem_01K465NX3K92G4FED4ENTQQBV0	sloc_01K465NX02PRA37GR065XPNVC1	1000000	0	0	\N	{"value": "1000000", "precision": 20}	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}
ilev_01K465NX5AVEG7JNXARANXQDP2	2025-09-03 03:05:11.531+05:30	2025-09-03 04:57:25.966+05:30	2025-09-03 04:57:25.957+05:30	iitem_01K465NX3KZQAGR8TJD8KM2MJ6	sloc_01K465NX02PRA37GR065XPNVC1	1000000	0	0	\N	{"value": "1000000", "precision": 20}	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}
ilev_01K465NX5A8BTME1CAQ4VVEXFE	2025-09-03 03:05:11.531+05:30	2025-09-03 04:57:25.971+05:30	2025-09-03 04:57:25.957+05:30	iitem_01K465NX3K3V01QEXHAZA3XRPF	sloc_01K465NX02PRA37GR065XPNVC1	1000000	0	0	\N	{"value": "1000000", "precision": 20}	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}
ilev_01K465NX5AKQETHTXNG8TE13FY	2025-09-03 03:05:11.531+05:30	2025-09-03 04:57:25.975+05:30	2025-09-03 04:57:25.957+05:30	iitem_01K465NX3KGGW9PBGMA6QZ8639	sloc_01K465NX02PRA37GR065XPNVC1	1000000	0	0	\N	{"value": "1000000", "precision": 20}	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}
ilev_01K465NX5A6D83K52Z37J1PJJT	2025-09-03 03:05:11.531+05:30	2025-09-03 04:57:28.756+05:30	2025-09-03 04:57:28.751+05:30	iitem_01K465NX3K0TTEHQD5MPKTN77K	sloc_01K465NX02PRA37GR065XPNVC1	1000000	0	0	\N	{"value": "1000000", "precision": 20}	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}
ilev_01K465NX5AKY3A7AD36FZ608M8	2025-09-03 03:05:11.531+05:30	2025-09-03 04:57:28.759+05:30	2025-09-03 04:57:28.751+05:30	iitem_01K465NX3KDM01XEXK1CDXT1S1	sloc_01K465NX02PRA37GR065XPNVC1	1000000	0	0	\N	{"value": "1000000", "precision": 20}	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}
ilev_01K465NX5AW7QNWGG9MAK7K0S1	2025-09-03 03:05:11.531+05:30	2025-09-03 04:57:28.762+05:30	2025-09-03 04:57:28.751+05:30	iitem_01K465NX3K3JE3ZGA8N1JEPAN4	sloc_01K465NX02PRA37GR065XPNVC1	1000000	0	0	\N	{"value": "1000000", "precision": 20}	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}
ilev_01K465NX5AQ9Z6XZSH2K9RC3GF	2025-09-03 03:05:11.531+05:30	2025-09-03 04:57:28.765+05:30	2025-09-03 04:57:28.751+05:30	iitem_01K465NX3KFA9HZKP6DTS54DVM	sloc_01K465NX02PRA37GR065XPNVC1	1000000	0	0	\N	{"value": "1000000", "precision": 20}	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}
ilev_01K465NX5AS1XDXVY9WARTH767	2025-09-03 03:05:11.531+05:30	2025-09-03 04:58:46.235+05:30	2025-09-03 04:58:46.218+05:30	iitem_01K465NX3KPDDV32DQZK5TAE5M	sloc_01K465NX02PRA37GR065XPNVC1	1000000	0	0	\N	{"value": "1000000", "precision": 20}	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}
ilev_01K465NX5A8RDEZKFM2Z390KX7	2025-09-03 03:05:11.531+05:30	2025-09-03 04:58:46.224+05:30	2025-09-03 04:58:46.218+05:30	iitem_01K465NX3K5H8B3VZ9R15WX93C	sloc_01K465NX02PRA37GR065XPNVC1	1000000	0	0	\N	{"value": "1000000", "precision": 20}	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}
ilev_01K465NX5AZKF3JMKT0SFFNWDN	2025-09-03 03:05:11.531+05:30	2025-09-03 04:58:46.227+05:30	2025-09-03 04:58:46.218+05:30	iitem_01K465NX3KZKX8H25Q1EWVPZC6	sloc_01K465NX02PRA37GR065XPNVC1	1000000	0	0	\N	{"value": "1000000", "precision": 20}	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}
ilev_01K465NX5A5Z6TF0206BX21W7R	2025-09-03 03:05:11.531+05:30	2025-09-03 04:58:46.238+05:30	2025-09-03 04:58:46.218+05:30	iitem_01K465NX3KBWKB951V07M21BEF	sloc_01K465NX02PRA37GR065XPNVC1	1000000	0	0	\N	{"value": "1000000", "precision": 20}	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}
ilev_01K465NX5AD74MM8H3KSFT0N4F	2025-09-03 03:05:11.531+05:30	2025-09-03 04:58:46.241+05:30	2025-09-03 04:58:46.218+05:30	iitem_01K465NX3KKGH4WP9ZWEVFEP0Z	sloc_01K465NX02PRA37GR065XPNVC1	1000000	0	0	\N	{"value": "1000000", "precision": 20}	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}
ilev_01K465NX5AJA1BC45GEQ8ZP4S8	2025-09-03 03:05:11.531+05:30	2025-09-03 04:58:46.245+05:30	2025-09-03 04:58:46.218+05:30	iitem_01K465NX3K9RWBBSYGQ8SGS1SD	sloc_01K465NX02PRA37GR065XPNVC1	1000000	0	0	\N	{"value": "1000000", "precision": 20}	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}
ilev_01K465NX5AZHFGCRZRK7ZBT5PG	2025-09-03 03:05:11.531+05:30	2025-09-03 04:58:46.248+05:30	2025-09-03 04:58:46.218+05:30	iitem_01K465NX3KJHWDDPGH9ZVGAYQX	sloc_01K465NX02PRA37GR065XPNVC1	1000000	0	0	\N	{"value": "1000000", "precision": 20}	{"value": "0", "precision": 20}	{"value": "0", "precision": 20}
\.


--
-- Data for Name: invite; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.invite (id, email, accepted, token, expires_at, metadata, created_at, updated_at, deleted_at) FROM stdin;
invite_01K465NVAV73QZM95WPCD8N4YX	admin@medusa-test.com	f	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6Imludml0ZV8wMUs0NjVOVkFWNzNRWk05NVdQQ0Q4TjRZWCIsImVtYWlsIjoiYWRtaW5AbWVkdXNhLXRlc3QuY29tIiwiaWF0IjoxNzU2ODQ4OTA5LCJleHAiOjE3NTY5MzUzMDksImp0aSI6ImZlYzM1MzI0LTU5NzQtNDVlMi05ZWYyLWQ3NDFhYTBjM2RiYSJ9.RqZN6SdLQjQTtRkTluFvdWpi1geBpNWJElYoEurmMj4	2025-09-04 03:05:09.659+05:30	\N	2025-09-03 03:05:09.662+05:30	2025-09-03 03:05:09.662+05:30	\N
\.


--
-- Data for Name: link_module_migrations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.link_module_migrations (id, table_name, link_descriptor, created_at) FROM stdin;
1	cart_promotion	{"toModel": "promotions", "toModule": "promotion", "fromModel": "cart", "fromModule": "cart"}	2025-09-03 03:05:05.88914
4	order_cart	{"toModel": "cart", "toModule": "cart", "fromModel": "order", "fromModule": "order"}	2025-09-03 03:05:05.889743
12	publishable_api_key_sales_channel	{"toModel": "sales_channel", "toModule": "sales_channel", "fromModel": "api_key", "fromModule": "api_key"}	2025-09-03 03:05:05.894762
14	sales_channel_stock_location	{"toModel": "location", "toModule": "stock_location", "fromModel": "sales_channel", "fromModule": "sales_channel"}	2025-09-03 03:05:05.895919
2	location_fulfillment_provider	{"toModel": "fulfillment_provider", "toModule": "fulfillment", "fromModel": "location", "fromModule": "stock_location"}	2025-09-03 03:05:05.889377
13	region_payment_provider	{"toModel": "payment_provider", "toModule": "payment", "fromModel": "region", "fromModule": "region"}	2025-09-03 03:05:05.895798
3	location_fulfillment_set	{"toModel": "fulfillment_set", "toModule": "fulfillment", "fromModel": "location", "fromModule": "stock_location"}	2025-09-03 03:05:05.889562
15	shipping_option_price_set	{"toModel": "price_set", "toModule": "pricing", "fromModel": "shipping_option", "fromModule": "fulfillment"}	2025-09-03 03:05:05.895991
6	order_promotion	{"toModel": "promotions", "toModule": "promotion", "fromModel": "order", "fromModule": "order"}	2025-09-03 03:05:05.892313
8	return_fulfillment	{"toModel": "fulfillments", "toModule": "fulfillment", "fromModel": "return", "fromModule": "order"}	2025-09-03 03:05:05.893632
11	product_variant_inventory_item	{"toModel": "inventory", "toModule": "inventory", "fromModel": "variant", "fromModule": "product"}	2025-09-03 03:05:05.894505
16	product_shipping_profile	{"toModel": "shipping_profile", "toModule": "fulfillment", "fromModel": "product", "fromModule": "product"}	2025-09-03 03:05:05.898873
18	cart_payment_collection	{"toModel": "payment_collection", "toModule": "payment", "fromModel": "cart", "fromModule": "cart"}	2025-09-03 03:05:05.898954
5	order_fulfillment	{"toModel": "fulfillments", "toModule": "fulfillment", "fromModel": "order", "fromModule": "order"}	2025-09-03 03:05:05.890063
7	order_payment_collection	{"toModel": "payment_collection", "toModule": "payment", "fromModel": "order", "fromModule": "order"}	2025-09-03 03:05:05.892214
9	product_sales_channel	{"toModel": "sales_channel", "toModule": "sales_channel", "fromModel": "product", "fromModule": "product"}	2025-09-03 03:05:05.893672
10	product_variant_price_set	{"toModel": "price_set", "toModule": "pricing", "fromModel": "variant", "fromModule": "product"}	2025-09-03 03:05:05.894619
17	customer_account_holder	{"toModel": "account_holder", "toModule": "payment", "fromModel": "customer", "fromModule": "customer"}	2025-09-03 03:05:05.898916
\.


--
-- Data for Name: location_fulfillment_provider; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.location_fulfillment_provider (stock_location_id, fulfillment_provider_id, id, created_at, updated_at, deleted_at) FROM stdin;
sloc_01K465NX02PRA37GR065XPNVC1	manual_manual	locfp_01K465NX06X385RMQ09P1HK9F1	2025-09-03 03:05:11.365956+05:30	2025-09-03 03:05:11.365956+05:30	\N
\.


--
-- Data for Name: location_fulfillment_set; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.location_fulfillment_set (stock_location_id, fulfillment_set_id, id, created_at, updated_at, deleted_at) FROM stdin;
sloc_01K465NX02PRA37GR065XPNVC1	fuset_01K465NX0BS3XBXW4G9VJ79T0Z	locfs_01K465NX0HC3BV91NE3XA4H17M	2025-09-03 03:05:11.377212+05:30	2025-09-03 03:05:11.377212+05:30	\N
\.


--
-- Data for Name: mikro_orm_migrations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.mikro_orm_migrations (id, name, executed_at) FROM stdin;
1	Migration20240307161216	2025-09-03 03:05:04.269447+05:30
2	Migration20241210073813	2025-09-03 03:05:04.269447+05:30
3	Migration20250106142624	2025-09-03 03:05:04.269447+05:30
4	Migration20250120110820	2025-09-03 03:05:04.269447+05:30
5	Migration20240307132720	2025-09-03 03:05:04.370801+05:30
6	Migration20240719123015	2025-09-03 03:05:04.370801+05:30
7	Migration20241213063611	2025-09-03 03:05:04.370801+05:30
8	InitialSetup20240401153642	2025-09-03 03:05:04.40981+05:30
9	Migration20240601111544	2025-09-03 03:05:04.40981+05:30
10	Migration202408271511	2025-09-03 03:05:04.40981+05:30
11	Migration20241122120331	2025-09-03 03:05:04.40981+05:30
12	Migration20241125090957	2025-09-03 03:05:04.40981+05:30
13	Migration20250411073236	2025-09-03 03:05:04.40981+05:30
14	Migration20250516081326	2025-09-03 03:05:04.40981+05:30
15	Migration20230929122253	2025-09-03 03:05:04.473917+05:30
16	Migration20240322094407	2025-09-03 03:05:04.473917+05:30
17	Migration20240322113359	2025-09-03 03:05:04.473917+05:30
18	Migration20240322120125	2025-09-03 03:05:04.473917+05:30
19	Migration20240626133555	2025-09-03 03:05:04.473917+05:30
20	Migration20240704094505	2025-09-03 03:05:04.473917+05:30
21	Migration20241127114534	2025-09-03 03:05:04.473917+05:30
22	Migration20241127223829	2025-09-03 03:05:04.473917+05:30
23	Migration20241128055359	2025-09-03 03:05:04.473917+05:30
24	Migration20241212190401	2025-09-03 03:05:04.473917+05:30
25	Migration20250408145122	2025-09-03 03:05:04.473917+05:30
26	Migration20250409122219	2025-09-03 03:05:04.473917+05:30
27	Migration20240227120221	2025-09-03 03:05:04.536098+05:30
28	Migration20240617102917	2025-09-03 03:05:04.536098+05:30
29	Migration20240624153824	2025-09-03 03:05:04.536098+05:30
30	Migration20241211061114	2025-09-03 03:05:04.536098+05:30
31	Migration20250113094144	2025-09-03 03:05:04.536098+05:30
32	Migration20250120110700	2025-09-03 03:05:04.536098+05:30
33	Migration20250226130616	2025-09-03 03:05:04.536098+05:30
34	Migration20250508081510	2025-09-03 03:05:04.536098+05:30
35	Migration20240124154000	2025-09-03 03:05:04.592041+05:30
36	Migration20240524123112	2025-09-03 03:05:04.592041+05:30
37	Migration20240602110946	2025-09-03 03:05:04.592041+05:30
38	Migration20241211074630	2025-09-03 03:05:04.592041+05:30
39	Migration20240115152146	2025-09-03 03:05:04.625005+05:30
40	Migration20240222170223	2025-09-03 03:05:04.644754+05:30
41	Migration20240831125857	2025-09-03 03:05:04.644754+05:30
42	Migration20241106085918	2025-09-03 03:05:04.644754+05:30
43	Migration20241205095237	2025-09-03 03:05:04.644754+05:30
44	Migration20241216183049	2025-09-03 03:05:04.644754+05:30
45	Migration20241218091938	2025-09-03 03:05:04.644754+05:30
46	Migration20250120115059	2025-09-03 03:05:04.644754+05:30
47	Migration20250212131240	2025-09-03 03:05:04.644754+05:30
48	Migration20250326151602	2025-09-03 03:05:04.644754+05:30
49	Migration20250508081553	2025-09-03 03:05:04.644754+05:30
50	Migration20240205173216	2025-09-03 03:05:04.700486+05:30
51	Migration20240624200006	2025-09-03 03:05:04.700486+05:30
52	Migration20250120110744	2025-09-03 03:05:04.700486+05:30
53	InitialSetup20240221144943	2025-09-03 03:05:04.761776+05:30
54	Migration20240604080145	2025-09-03 03:05:04.761776+05:30
55	Migration20241205122700	2025-09-03 03:05:04.761776+05:30
56	InitialSetup20240227075933	2025-09-03 03:05:04.783021+05:30
57	Migration20240621145944	2025-09-03 03:05:04.783021+05:30
58	Migration20241206083313	2025-09-03 03:05:04.783021+05:30
59	Migration20240227090331	2025-09-03 03:05:04.805247+05:30
60	Migration20240710135844	2025-09-03 03:05:04.805247+05:30
61	Migration20240924114005	2025-09-03 03:05:04.805247+05:30
62	Migration20241212052837	2025-09-03 03:05:04.805247+05:30
63	InitialSetup20240228133303	2025-09-03 03:05:04.863497+05:30
64	Migration20240624082354	2025-09-03 03:05:04.863497+05:30
65	Migration20240225134525	2025-09-03 03:05:04.947594+05:30
66	Migration20240806072619	2025-09-03 03:05:04.947594+05:30
67	Migration20241211151053	2025-09-03 03:05:04.947594+05:30
68	Migration20250115160517	2025-09-03 03:05:04.947594+05:30
69	Migration20250120110552	2025-09-03 03:05:04.947594+05:30
70	Migration20250123122334	2025-09-03 03:05:04.947594+05:30
71	Migration20250206105639	2025-09-03 03:05:04.947594+05:30
72	Migration20250207132723	2025-09-03 03:05:04.947594+05:30
73	Migration20250625084134	2025-09-03 03:05:04.947594+05:30
74	Migration20240219102530	2025-09-03 03:05:05.027666+05:30
75	Migration20240604100512	2025-09-03 03:05:05.027666+05:30
76	Migration20240715102100	2025-09-03 03:05:05.027666+05:30
77	Migration20240715174100	2025-09-03 03:05:05.027666+05:30
78	Migration20240716081800	2025-09-03 03:05:05.027666+05:30
79	Migration20240801085921	2025-09-03 03:05:05.027666+05:30
80	Migration20240821164505	2025-09-03 03:05:05.027666+05:30
81	Migration20240821170920	2025-09-03 03:05:05.027666+05:30
82	Migration20240827133639	2025-09-03 03:05:05.027666+05:30
83	Migration20240902195921	2025-09-03 03:05:05.027666+05:30
84	Migration20240913092514	2025-09-03 03:05:05.027666+05:30
85	Migration20240930122627	2025-09-03 03:05:05.027666+05:30
86	Migration20241014142943	2025-09-03 03:05:05.027666+05:30
87	Migration20241106085223	2025-09-03 03:05:05.027666+05:30
88	Migration20241129124827	2025-09-03 03:05:05.027666+05:30
89	Migration20241217162224	2025-09-03 03:05:05.027666+05:30
90	Migration20250326151554	2025-09-03 03:05:05.027666+05:30
91	Migration20250522181137	2025-09-03 03:05:05.027666+05:30
92	Migration20250702095353	2025-09-03 03:05:05.027666+05:30
93	Migration20250704120229	2025-09-03 03:05:05.027666+05:30
94	Migration20250717162007	2025-09-03 03:05:05.156207+05:30
95	Migration20240205025928	2025-09-03 03:05:05.193172+05:30
96	Migration20240529080336	2025-09-03 03:05:05.193172+05:30
97	Migration20241202100304	2025-09-03 03:05:05.193172+05:30
98	Migration20240214033943	2025-09-03 03:05:05.290336+05:30
99	Migration20240703095850	2025-09-03 03:05:05.290336+05:30
100	Migration20241202103352	2025-09-03 03:05:05.290336+05:30
101	Migration20240311145700_InitialSetupMigration	2025-09-03 03:05:05.318174+05:30
102	Migration20240821170957	2025-09-03 03:05:05.318174+05:30
103	Migration20240917161003	2025-09-03 03:05:05.318174+05:30
104	Migration20241217110416	2025-09-03 03:05:05.318174+05:30
105	Migration20250113122235	2025-09-03 03:05:05.318174+05:30
106	Migration20250120115002	2025-09-03 03:05:05.318174+05:30
107	Migration20250822130931	2025-09-03 03:05:05.318174+05:30
108	Migration20250825132614	2025-09-03 03:05:05.318174+05:30
109	Migration20240509083918_InitialSetupMigration	2025-09-03 03:05:05.397816+05:30
110	Migration20240628075401	2025-09-03 03:05:05.397816+05:30
111	Migration20240830094712	2025-09-03 03:05:05.397816+05:30
112	Migration20250120110514	2025-09-03 03:05:05.397816+05:30
113	Migration20231228143900	2025-09-03 03:05:05.487271+05:30
114	Migration20241206101446	2025-09-03 03:05:05.487271+05:30
115	Migration20250128174331	2025-09-03 03:05:05.487271+05:30
116	Migration20250505092459	2025-09-03 03:05:05.487271+05:30
117	Migration20250819104213	2025-09-03 03:05:05.487271+05:30
\.


--
-- Data for Name: notification; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.notification (id, "to", channel, template, data, trigger_type, resource_id, resource_type, receiver_id, original_notification_id, idempotency_key, external_id, provider_id, created_at, updated_at, deleted_at, status) FROM stdin;
\.


--
-- Data for Name: notification_provider; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.notification_provider (id, handle, name, is_enabled, channels, created_at, updated_at, deleted_at) FROM stdin;
local	local	local	t	{feed}	2025-09-03 03:05:07.458+05:30	2025-09-03 03:05:07.458+05:30	\N
\.


--
-- Data for Name: order; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."order" (id, region_id, display_id, customer_id, version, sales_channel_id, status, is_draft_order, email, currency_code, shipping_address_id, billing_address_id, no_notification, metadata, created_at, updated_at, deleted_at, canceled_at) FROM stdin;
order_01K46A1CNQR8DGVZ9N6RMYNSV5	reg_01K465NWZBB589QBS334WRK4PF	1	cus_01K46A0ZPRWKCSMQAW51DY0W8R	4	sc_01K465NVAAFMSJ0RGP5VCKEPVH	pending	f	mk@mk.com	eur	ordaddr_01K46A1CNKC3FAXGCPGK2CFN0G	ordaddr_01K46A1CNKR8AAC0SG2XMKJRNY	f	\N	2025-09-03 04:21:22.169+05:30	2025-09-03 04:58:38.384+05:30	\N	\N
\.


--
-- Data for Name: order_address; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_address (id, customer_id, company, first_name, last_name, address_1, address_2, city, country_code, province, postal_code, phone, metadata, created_at, updated_at, deleted_at) FROM stdin;
ordaddr_01K46A1CNKR8AAC0SG2XMKJRNY	\N		test	test	test		varanasi	it	up	221002		\N	2025-09-03 04:21:08.95+05:30	2025-09-03 04:21:08.95+05:30	\N
ordaddr_01K46A1CNKC3FAXGCPGK2CFN0G	\N		test	test	test		varanasi	it	up	221002		\N	2025-09-03 04:21:08.95+05:30	2025-09-03 04:21:08.95+05:30	\N
\.


--
-- Data for Name: order_cart; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_cart (order_id, cart_id, id, created_at, updated_at, deleted_at) FROM stdin;
order_01K46A1CNQR8DGVZ9N6RMYNSV5	cart_01K466AXHFNSF95BC7REXFZ8B0	ordercart_01K46A1CR9JQSG9BHCNMP1JY7M	2025-09-03 04:21:22.247216+05:30	2025-09-03 04:21:22.247216+05:30	\N
\.


--
-- Data for Name: order_change; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_change (id, order_id, version, description, status, internal_note, created_by, requested_by, requested_at, confirmed_by, confirmed_at, declined_by, declined_reason, metadata, declined_at, canceled_by, canceled_at, created_at, updated_at, change_type, deleted_at, return_id, claim_id, exchange_id) FROM stdin;
ordch_01K46C5DF7Z3XG31QGE8XTA9DZ	order_01K46A1CNQR8DGVZ9N6RMYNSV5	2	\N	confirmed	\N	\N	\N	\N	\N	2025-09-03 04:58:31.226+05:30	\N	\N	\N	\N	\N	\N	2025-09-03 04:58:31.208+05:30	2025-09-03 04:58:31.229+05:30	\N	\N	\N	\N	\N
ordch_01K46C5J7B57PNXES4VEG51GTV	order_01K46A1CNQR8DGVZ9N6RMYNSV5	3	\N	confirmed	\N	\N	\N	\N	\N	2025-09-03 04:58:36.081+05:30	\N	\N	\N	\N	\N	\N	2025-09-03 04:58:36.075+05:30	2025-09-03 04:58:36.082+05:30	\N	\N	\N	\N	\N
ordch_01K46C5MEB6GGRDYFET7ABZ7F1	order_01K46A1CNQR8DGVZ9N6RMYNSV5	4	\N	confirmed	\N	\N	\N	\N	\N	2025-09-03 04:58:38.357+05:30	\N	\N	\N	\N	\N	\N	2025-09-03 04:58:38.347+05:30	2025-09-03 04:58:38.362+05:30	\N	\N	\N	\N	\N
\.


--
-- Data for Name: order_change_action; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_change_action (id, order_id, version, ordering, order_change_id, reference, reference_id, action, details, amount, raw_amount, internal_note, applied, created_at, updated_at, deleted_at, return_id, claim_id, exchange_id) FROM stdin;
ordchact_01K46C5DF7176JMX7Q32HTNJB0	order_01K46A1CNQR8DGVZ9N6RMYNSV5	2	1	ordch_01K46C5DF7Z3XG31QGE8XTA9DZ	fulfillment	ful_01K46C5DDKVJY90P99FVD3GDK2	FULFILL_ITEM	{"quantity": 1, "reference_id": "ordli_01K46A1CNQC8HHYQH4KJ54AGP4"}	\N	\N	\N	t	2025-09-03 04:58:31.208+05:30	2025-09-03 04:58:31.258+05:30	\N	\N	\N	\N
ordchact_01K46C5J7BJ8WRNPMT5BQ9KY9S	order_01K46A1CNQR8DGVZ9N6RMYNSV5	3	2	ordch_01K46C5J7B57PNXES4VEG51GTV	fulfillment	ful_01K46C5DDKVJY90P99FVD3GDK2	SHIP_ITEM	{"quantity": "1", "reference_id": "ordli_01K46A1CNQC8HHYQH4KJ54AGP4"}	\N	\N	\N	t	2025-09-03 04:58:36.075+05:30	2025-09-03 04:58:36.103+05:30	\N	\N	\N	\N
ordchact_01K46C5MEAVBTVS9R2SRM9PHDV	order_01K46A1CNQR8DGVZ9N6RMYNSV5	4	3	ordch_01K46C5MEB6GGRDYFET7ABZ7F1	fulfillment	ful_01K46C5DDKVJY90P99FVD3GDK2	DELIVER_ITEM	{"quantity": "1", "reference_id": "ordli_01K46A1CNQC8HHYQH4KJ54AGP4"}	\N	\N	\N	t	2025-09-03 04:58:38.347+05:30	2025-09-03 04:58:38.384+05:30	\N	\N	\N	\N
\.


--
-- Data for Name: order_claim; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_claim (id, order_id, return_id, order_version, display_id, type, no_notification, refund_amount, raw_refund_amount, metadata, created_at, updated_at, deleted_at, canceled_at, created_by) FROM stdin;
\.


--
-- Data for Name: order_claim_item; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_claim_item (id, claim_id, item_id, is_additional_item, reason, quantity, raw_quantity, note, metadata, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: order_claim_item_image; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_claim_item_image (id, claim_item_id, url, metadata, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: order_credit_line; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_credit_line (id, order_id, reference, reference_id, amount, raw_amount, metadata, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: order_exchange; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_exchange (id, order_id, return_id, order_version, display_id, no_notification, allow_backorder, difference_due, raw_difference_due, metadata, created_at, updated_at, deleted_at, canceled_at, created_by) FROM stdin;
\.


--
-- Data for Name: order_exchange_item; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_exchange_item (id, exchange_id, item_id, quantity, raw_quantity, note, metadata, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: order_fulfillment; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_fulfillment (order_id, fulfillment_id, id, created_at, updated_at, deleted_at) FROM stdin;
order_01K46A1CNQR8DGVZ9N6RMYNSV5	ful_01K46C5DDKVJY90P99FVD3GDK2	ordful_01K46C5DF0A4QZY9WKR96E8XTX	2025-09-03 04:58:31.193471+05:30	2025-09-03 04:58:31.193471+05:30	\N
\.


--
-- Data for Name: order_item; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_item (id, order_id, version, item_id, quantity, raw_quantity, fulfilled_quantity, raw_fulfilled_quantity, shipped_quantity, raw_shipped_quantity, return_requested_quantity, raw_return_requested_quantity, return_received_quantity, raw_return_received_quantity, return_dismissed_quantity, raw_return_dismissed_quantity, written_off_quantity, raw_written_off_quantity, metadata, created_at, updated_at, deleted_at, delivered_quantity, raw_delivered_quantity, unit_price, raw_unit_price, compare_at_unit_price, raw_compare_at_unit_price) FROM stdin;
orditem_01K46A1CNRDSB7SN2J8MTRH6NH	order_01K46A1CNQR8DGVZ9N6RMYNSV5	1	ordli_01K46A1CNQC8HHYQH4KJ54AGP4	1	{"value": "1", "precision": 20}	0	{"value": "0", "precision": 20}	0	{"value": "0", "precision": 20}	0	{"value": "0", "precision": 20}	0	{"value": "0", "precision": 20}	0	{"value": "0", "precision": 20}	0	{"value": "0", "precision": 20}	\N	2025-09-03 04:21:22.169+05:30	2025-09-03 04:21:22.169+05:30	\N	0	{"value": "0", "precision": 20}	\N	\N	\N	\N
orditem_01K46C5DGMG8SSZ20CGHFTT1NQ	order_01K46A1CNQR8DGVZ9N6RMYNSV5	2	ordli_01K46A1CNQC8HHYQH4KJ54AGP4	1	{"value": "1", "precision": 20}	1	{"value": "1", "precision": 20}	0	{"value": "0", "precision": 20}	0	{"value": "0", "precision": 20}	0	{"value": "0", "precision": 20}	0	{"value": "0", "precision": 20}	0	{"value": "0", "precision": 20}	\N	2025-09-03 04:58:31.258+05:30	2025-09-03 04:58:31.258+05:30	\N	0	{"value": "0", "precision": 20}	10	{"value": "10", "precision": 20}	\N	\N
orditem_01K46C5J83TRXFE1K1CANRCQH3	order_01K46A1CNQR8DGVZ9N6RMYNSV5	3	ordli_01K46A1CNQC8HHYQH4KJ54AGP4	1	{"value": "1", "precision": 20}	1	{"value": "1", "precision": 20}	1	{"value": "1", "precision": 20}	0	{"value": "0", "precision": 20}	0	{"value": "0", "precision": 20}	0	{"value": "0", "precision": 20}	0	{"value": "0", "precision": 20}	\N	2025-09-03 04:58:36.102+05:30	2025-09-03 04:58:36.102+05:30	\N	0	{"value": "0", "precision": 20}	10	{"value": "10", "precision": 20}	\N	\N
orditem_01K46C5MFBHSPFZZ35ME3BP1KB	order_01K46A1CNQR8DGVZ9N6RMYNSV5	4	ordli_01K46A1CNQC8HHYQH4KJ54AGP4	1	{"value": "1", "precision": 20}	1	{"value": "1", "precision": 20}	1	{"value": "1", "precision": 20}	0	{"value": "0", "precision": 20}	0	{"value": "0", "precision": 20}	0	{"value": "0", "precision": 20}	0	{"value": "0", "precision": 20}	\N	2025-09-03 04:58:38.384+05:30	2025-09-03 04:58:38.384+05:30	\N	1	{"value": "1", "precision": 20}	10	{"value": "10", "precision": 20}	\N	\N
\.


--
-- Data for Name: order_line_item; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_line_item (id, totals_id, title, subtitle, thumbnail, variant_id, product_id, product_title, product_description, product_subtitle, product_type, product_collection, product_handle, variant_sku, variant_barcode, variant_title, variant_option_values, requires_shipping, is_discountable, is_tax_inclusive, compare_at_unit_price, raw_compare_at_unit_price, unit_price, raw_unit_price, metadata, created_at, updated_at, deleted_at, is_custom_price, product_type_id, is_giftcard) FROM stdin;
ordli_01K46A1CNQC8HHYQH4KJ54AGP4	\N	Medusa T-Shirt	M / Black	https://medusa-public-images.s3.eu-west-1.amazonaws.com/tee-black-front.png	variant_01K465NX36QVW4VT9ZBR1WEYPA	prod_01K465NX26VFWW6C9Y3GJN3K6V	Medusa T-Shirt	Reimagine the feeling of a classic T-shirt. With our cotton T-shirts, everyday essentials no longer have to be ordinary.	\N	\N	\N	t-shirt	SHIRT-M-BLACK	\N	M / Black	\N	t	t	f	\N	\N	10	{"value": "10", "precision": 20}	{}	2025-09-03 04:21:22.169+05:30	2025-09-03 04:21:22.169+05:30	\N	f	\N	f
\.


--
-- Data for Name: order_line_item_adjustment; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_line_item_adjustment (id, description, promotion_id, code, amount, raw_amount, provider_id, created_at, updated_at, item_id, deleted_at, is_tax_inclusive) FROM stdin;
\.


--
-- Data for Name: order_line_item_tax_line; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_line_item_tax_line (id, description, tax_rate_id, code, rate, raw_rate, provider_id, created_at, updated_at, item_id, deleted_at) FROM stdin;
\.


--
-- Data for Name: order_payment_collection; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_payment_collection (order_id, payment_collection_id, id, created_at, updated_at, deleted_at) FROM stdin;
order_01K46A1CNQR8DGVZ9N6RMYNSV5	pay_col_01K46A16VZNY85A3HR7P2TGF0T	ordpay_01K46A1CR98XNKFQ630PFKG980	2025-09-03 04:21:22.248704+05:30	2025-09-03 04:21:22.248704+05:30	\N
\.


--
-- Data for Name: order_promotion; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_promotion (order_id, promotion_id, id, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: order_shipping; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_shipping (id, order_id, version, shipping_method_id, created_at, updated_at, deleted_at, return_id, claim_id, exchange_id) FROM stdin;
ordspmv_01K46A1CNPHSSRNNQ6R7D29J1D	order_01K46A1CNQR8DGVZ9N6RMYNSV5	1	ordsm_01K46A1CNPCCWDKAHX56BZ71W5	2025-09-03 04:21:22.169+05:30	2025-09-03 04:21:22.169+05:30	\N	\N	\N	\N
ordspmv_01K46C5DGMAB0WQ14CP3A7AA8S	order_01K46A1CNQR8DGVZ9N6RMYNSV5	2	ordsm_01K46A1CNPCCWDKAHX56BZ71W5	2025-09-03 04:21:22.169+05:30	2025-09-03 04:21:22.169+05:30	\N	\N	\N	\N
ordspmv_01K46C5J83TS4XK4B7Y431KNAX	order_01K46A1CNQR8DGVZ9N6RMYNSV5	3	ordsm_01K46A1CNPCCWDKAHX56BZ71W5	2025-09-03 04:21:22.169+05:30	2025-09-03 04:21:22.169+05:30	\N	\N	\N	\N
ordspmv_01K46C5MFCCKMNM16JPQKZM52A	order_01K46A1CNQR8DGVZ9N6RMYNSV5	4	ordsm_01K46A1CNPCCWDKAHX56BZ71W5	2025-09-03 04:21:22.169+05:30	2025-09-03 04:21:22.169+05:30	\N	\N	\N	\N
\.


--
-- Data for Name: order_shipping_method; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_shipping_method (id, name, description, amount, raw_amount, is_tax_inclusive, shipping_option_id, data, metadata, created_at, updated_at, deleted_at, is_custom_amount) FROM stdin;
ordsm_01K46A1CNPCCWDKAHX56BZ71W5	Standard Shipping	\N	10	{"value": "10", "precision": 20}	f	so_01K465NX0W8FHES8P37CAFHZS3	{}	\N	2025-09-03 04:21:22.169+05:30	2025-09-03 04:21:22.169+05:30	\N	f
\.


--
-- Data for Name: order_shipping_method_adjustment; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_shipping_method_adjustment (id, description, promotion_id, code, amount, raw_amount, provider_id, created_at, updated_at, shipping_method_id, deleted_at) FROM stdin;
\.


--
-- Data for Name: order_shipping_method_tax_line; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_shipping_method_tax_line (id, description, tax_rate_id, code, rate, raw_rate, provider_id, created_at, updated_at, shipping_method_id, deleted_at) FROM stdin;
\.


--
-- Data for Name: order_summary; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_summary (id, order_id, version, totals, created_at, updated_at, deleted_at) FROM stdin;
ordsum_01K46A1CNPSJBD81R2KGMX600G	order_01K46A1CNQR8DGVZ9N6RMYNSV5	1	{"paid_total": 20, "raw_paid_total": {"value": "20", "precision": 20}, "refunded_total": 0, "accounting_total": 20, "credit_line_total": 0, "transaction_total": 20, "pending_difference": 0, "raw_refunded_total": {"value": "0", "precision": 20}, "current_order_total": 20, "original_order_total": 20, "raw_accounting_total": {"value": "20", "precision": 20}, "raw_credit_line_total": {"value": "0", "precision": 20}, "raw_transaction_total": {"value": "20", "precision": 20}, "raw_pending_difference": {"value": "0", "precision": 20}, "raw_current_order_total": {"value": "20", "precision": 20}, "raw_original_order_total": {"value": "20", "precision": 20}}	2025-09-03 04:21:22.169+05:30	2025-09-03 04:58:25.785+05:30	\N
ordsum_01K46C5DGM0QQFW00RTNACX0YY	order_01K46A1CNQR8DGVZ9N6RMYNSV5	2	{"paid_total": 20, "raw_paid_total": {"value": "20", "precision": 20}, "refunded_total": 0, "accounting_total": 20, "credit_line_total": 0, "transaction_total": 20, "pending_difference": 0, "raw_refunded_total": {"value": "0", "precision": 20}, "current_order_total": 20, "original_order_total": 20, "raw_accounting_total": {"value": "20", "precision": 20}, "raw_credit_line_total": {"value": "0", "precision": 20}, "raw_transaction_total": {"value": "20", "precision": 20}, "raw_pending_difference": {"value": "0", "precision": 20}, "raw_current_order_total": {"value": "20", "precision": 20}, "raw_original_order_total": {"value": "20", "precision": 20}}	2025-09-03 04:58:31.258+05:30	2025-09-03 04:58:31.258+05:30	\N
ordsum_01K46C5J83CK0E1D54Z1YBEWK2	order_01K46A1CNQR8DGVZ9N6RMYNSV5	3	{"paid_total": 20, "raw_paid_total": {"value": "20", "precision": 20}, "refunded_total": 0, "accounting_total": 20, "credit_line_total": 0, "transaction_total": 20, "pending_difference": 0, "raw_refunded_total": {"value": "0", "precision": 20}, "current_order_total": 20, "original_order_total": 20, "raw_accounting_total": {"value": "20", "precision": 20}, "raw_credit_line_total": {"value": "0", "precision": 20}, "raw_transaction_total": {"value": "20", "precision": 20}, "raw_pending_difference": {"value": "0", "precision": 20}, "raw_current_order_total": {"value": "20", "precision": 20}, "raw_original_order_total": {"value": "20", "precision": 20}}	2025-09-03 04:58:36.102+05:30	2025-09-03 04:58:36.102+05:30	\N
ordsum_01K46C5MFC78D7E330DW2WC14M	order_01K46A1CNQR8DGVZ9N6RMYNSV5	4	{"paid_total": 20, "raw_paid_total": {"value": "20", "precision": 20}, "refunded_total": 0, "accounting_total": 20, "credit_line_total": 0, "transaction_total": 20, "pending_difference": 0, "raw_refunded_total": {"value": "0", "precision": 20}, "current_order_total": 20, "original_order_total": 20, "raw_accounting_total": {"value": "20", "precision": 20}, "raw_credit_line_total": {"value": "0", "precision": 20}, "raw_transaction_total": {"value": "20", "precision": 20}, "raw_pending_difference": {"value": "0", "precision": 20}, "raw_current_order_total": {"value": "20", "precision": 20}, "raw_original_order_total": {"value": "20", "precision": 20}}	2025-09-03 04:58:38.384+05:30	2025-09-03 04:58:38.384+05:30	\N
\.


--
-- Data for Name: order_transaction; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_transaction (id, order_id, version, amount, raw_amount, currency_code, reference, reference_id, created_at, updated_at, deleted_at, return_id, claim_id, exchange_id) FROM stdin;
ordtrx_01K46C585BA3VM8T2ZKQ6XZZ8J	order_01K46A1CNQR8DGVZ9N6RMYNSV5	1	20	{"value": "20", "precision": 20}	eur	capture	capt_01K46C5845REFPVZPA9ZB0GZJ4	2025-09-03 04:58:25.772+05:30	2025-09-03 04:58:25.772+05:30	\N	\N	\N	\N
\.


--
-- Data for Name: payment; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.payment (id, amount, raw_amount, currency_code, provider_id, data, created_at, updated_at, deleted_at, captured_at, canceled_at, payment_collection_id, payment_session_id, metadata) FROM stdin;
pay_01K46A1CS3H2RF78M2C6RFHV9X	20	{"value": "20", "precision": 20}	eur	pp_system_default	{}	2025-09-03 04:21:22.275+05:30	2025-09-03 04:58:25.746+05:30	\N	2025-09-03 04:58:25.74+05:30	\N	pay_col_01K46A16VZNY85A3HR7P2TGF0T	payses_01K46A16XPB4BJCMEGG737HHER	\N
\.


--
-- Data for Name: payment_collection; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.payment_collection (id, currency_code, amount, raw_amount, authorized_amount, raw_authorized_amount, captured_amount, raw_captured_amount, refunded_amount, raw_refunded_amount, created_at, updated_at, deleted_at, completed_at, status, metadata) FROM stdin;
pay_col_01K46A16VZNY85A3HR7P2TGF0T	eur	20	{"value": "20", "precision": 20}	20	{"value": "20", "precision": 20}	20	{"value": "20", "precision": 20}	0	{"value": "0", "precision": 20}	2025-09-03 04:21:16.223+05:30	2025-09-03 04:58:25.759+05:30	\N	2025-09-03 04:58:25.758+05:30	completed	\N
\.


--
-- Data for Name: payment_collection_payment_providers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.payment_collection_payment_providers (payment_collection_id, payment_provider_id) FROM stdin;
\.


--
-- Data for Name: payment_provider; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.payment_provider (id, is_enabled, created_at, updated_at, deleted_at) FROM stdin;
pp_system_default	t	2025-09-03 03:05:07.459+05:30	2025-09-03 03:05:07.459+05:30	\N
\.


--
-- Data for Name: payment_session; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.payment_session (id, currency_code, amount, raw_amount, provider_id, data, context, status, authorized_at, payment_collection_id, metadata, created_at, updated_at, deleted_at) FROM stdin;
payses_01K46A16XPB4BJCMEGG737HHER	eur	20	{"value": "20", "precision": 20}	pp_system_default	{}	{}	authorized	2025-09-03 04:21:22.274+05:30	pay_col_01K46A16VZNY85A3HR7P2TGF0T	{}	2025-09-03 04:21:16.278+05:30	2025-09-03 04:21:22.276+05:30	\N
\.


--
-- Data for Name: price; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.price (id, title, price_set_id, currency_code, raw_amount, rules_count, created_at, updated_at, deleted_at, price_list_id, amount, min_quantity, max_quantity) FROM stdin;
price_01K465NX135PCBC1E9Q2P5KJ36	\N	pset_01K465NX13CASJ8S3MJ3RY8NN0	usd	{"value": "10", "precision": 20}	0	2025-09-03 03:05:11.396+05:30	2025-09-03 03:05:11.396+05:30	\N	\N	10	\N	\N
price_01K465NX13YV0869BSEMPE88P6	\N	pset_01K465NX13CASJ8S3MJ3RY8NN0	eur	{"value": "10", "precision": 20}	0	2025-09-03 03:05:11.396+05:30	2025-09-03 03:05:11.396+05:30	\N	\N	10	\N	\N
price_01K465NX13NW3SRA7AEEZVFP07	\N	pset_01K465NX13CASJ8S3MJ3RY8NN0	eur	{"value": "10", "precision": 20}	1	2025-09-03 03:05:11.396+05:30	2025-09-03 03:05:11.396+05:30	\N	\N	10	\N	\N
price_01K465NX13T7YHWH1XW9ZG99B6	\N	pset_01K465NX1352A7Y6X0KEY321EJ	usd	{"value": "10", "precision": 20}	0	2025-09-03 03:05:11.396+05:30	2025-09-03 03:05:11.396+05:30	\N	\N	10	\N	\N
price_01K465NX13TY1CKHJ8E6RYH7K6	\N	pset_01K465NX1352A7Y6X0KEY321EJ	eur	{"value": "10", "precision": 20}	0	2025-09-03 03:05:11.396+05:30	2025-09-03 03:05:11.396+05:30	\N	\N	10	\N	\N
price_01K465NX13XX1MA71NZWE0ZCJ4	\N	pset_01K465NX1352A7Y6X0KEY321EJ	eur	{"value": "10", "precision": 20}	1	2025-09-03 03:05:11.396+05:30	2025-09-03 03:05:11.396+05:30	\N	\N	10	\N	\N
price_01K46C0X3BK9YWPPHRYYRZQD88	\N	pset_01K46B9PKJ91AES10GCHJEDDH6	php	{"value": "500", "precision": 20}	0	2025-09-03 04:56:03.373+05:30	2025-09-03 04:56:03.373+05:30	\N	\N	500	\N	\N
price_01K46C0X3Z55GTFYPCAW8FXYF4	\N	pset_01K46AVHDEJX8DTKKBYJN6FNSQ	php	{"value": "500", "precision": 20}	0	2025-09-03 04:56:03.392+05:30	2025-09-03 04:56:03.392+05:30	\N	\N	500	\N	\N
price_01K46C0WRHP1BG2EA191XGVRK9	\N	pset_01K465NX459GE16ZMJ8WJE53MM	php	{"value": "500", "precision": 20}	0	2025-09-03 04:56:03.027+05:30	2025-09-03 04:57:23.4+05:30	2025-09-03 04:57:23.395+05:30	\N	500	\N	\N
price_01K46C0WS4D74E2WY4G0CM2PBT	\N	pset_01K465NX45E8F05EVJ4CEVES91	php	{"value": "500", "precision": 20}	0	2025-09-03 04:56:03.047+05:30	2025-09-03 04:57:23.406+05:30	2025-09-03 04:57:23.395+05:30	\N	500	\N	\N
price_01K46C0WSRJJ6ZQA0YKBZJ1YXH	\N	pset_01K465NX455B6X7DES3W0CT3DG	php	{"value": "500", "precision": 20}	0	2025-09-03 04:56:03.066+05:30	2025-09-03 04:57:23.409+05:30	2025-09-03 04:57:23.395+05:30	\N	500	\N	\N
price_01K46C0WQEH98VHNXPS3PSMJ4N	\N	pset_01K465NX45MEKVF8PXZ3JRGNV9	php	{"value": "500", "precision": 20}	0	2025-09-03 04:56:02.995+05:30	2025-09-03 04:57:23.412+05:30	2025-09-03 04:57:23.395+05:30	\N	500	\N	\N
price_01K46C0WTSKGAZ10M5PGV1Y5AZ	\N	pset_01K465NX4410GFGVA840CYXGJW	php	{"value": "500", "precision": 20}	0	2025-09-03 04:56:03.099+05:30	2025-09-03 04:57:26.004+05:30	2025-09-03 04:57:26.001+05:30	\N	500	\N	\N
price_01K46C0WT9AWEDA91E46VTQF3R	\N	pset_01K465NX44QCB58J6WYE78AFHK	php	{"value": "500", "precision": 20}	0	2025-09-03 04:56:03.083+05:30	2025-09-03 04:57:26.009+05:30	2025-09-03 04:57:26.001+05:30	\N	500	\N	\N
price_01K46C0WVBDWZTQRXC7F2HD5WZ	\N	pset_01K465NX44DCB1BVXBQTS9915P	php	{"value": "500", "precision": 20}	0	2025-09-03 04:56:03.117+05:30	2025-09-03 04:57:26.013+05:30	2025-09-03 04:57:26.001+05:30	\N	500	\N	\N
price_01K46C0WVXS60F19SDR381G0Z9	\N	pset_01K465NX4444HQHPR1JKEHV0F8	php	{"value": "500", "precision": 20}	0	2025-09-03 04:56:03.135+05:30	2025-09-03 04:57:26.017+05:30	2025-09-03 04:57:26.001+05:30	\N	500	\N	\N
price_01K46C0WWJ32XBAEPBJV6QWQHK	\N	pset_01K465NX44M6BG4X08E4GA8HPB	php	{"value": "500", "precision": 20}	0	2025-09-03 04:56:03.156+05:30	2025-09-03 04:57:28.787+05:30	2025-09-03 04:57:28.782+05:30	\N	500	\N	\N
price_01K46C0WXM978BFMX8KPRCAB7K	\N	pset_01K465NX444TARD5C6P68061VE	php	{"value": "500", "precision": 20}	0	2025-09-03 04:56:03.189+05:30	2025-09-03 04:57:28.792+05:30	2025-09-03 04:57:28.782+05:30	\N	500	\N	\N
price_01K46C0WY4BTVEA6ZX4AQWDYYY	\N	pset_01K465NX44F5KQ2ZJT0A9DA1WS	php	{"value": "500", "precision": 20}	0	2025-09-03 04:56:03.207+05:30	2025-09-03 04:57:28.796+05:30	2025-09-03 04:57:28.782+05:30	\N	500	\N	\N
price_01K46C0WX4N6A5NCZ92FK9T461	\N	pset_01K465NX45XEM37BD7JPYVTPRW	php	{"value": "500", "precision": 20}	0	2025-09-03 04:56:03.174+05:30	2025-09-03 04:57:28.799+05:30	2025-09-03 04:57:28.782+05:30	\N	500	\N	\N
price_01K46C0X18BNZX8WD0VB164JJT	\N	pset_01K465NX43N5AYNJ6SRX65Z7ZY	php	{"value": "500", "precision": 20}	0	2025-09-03 04:56:03.305+05:30	2025-09-03 04:58:46.301+05:30	2025-09-03 04:58:46.297+05:30	\N	500	\N	\N
price_01K46C0X1SHWGW0SKZ6YYKFF3A	\N	pset_01K465NX433NY32ADJYYSZSKRH	php	{"value": "500", "precision": 20}	0	2025-09-03 04:56:03.323+05:30	2025-09-03 04:58:46.305+05:30	2025-09-03 04:58:46.297+05:30	\N	500	\N	\N
price_01K46C0X0MBJZ5YZHQ1X0TZCJH	\N	pset_01K465NX43RJEZDA9GXWEWXV6G	php	{"value": "500", "precision": 20}	0	2025-09-03 04:56:03.286+05:30	2025-09-03 04:58:46.308+05:30	2025-09-03 04:58:46.297+05:30	\N	500	\N	\N
price_01K46C0X2AB12Y5EB6CMV98YTY	\N	pset_01K465NX43FQ5Z8DDHQW27AQNX	php	{"value": "500", "precision": 20}	0	2025-09-03 04:56:03.34+05:30	2025-09-03 04:58:46.31+05:30	2025-09-03 04:58:46.297+05:30	\N	500	\N	\N
price_01K46C0WZCD9SPE3GDB2TWR70B	\N	pset_01K465NX445E51QVS66ZKGB0F3	php	{"value": "500", "precision": 20}	0	2025-09-03 04:56:03.246+05:30	2025-09-03 04:58:46.312+05:30	2025-09-03 04:58:46.297+05:30	\N	500	\N	\N
price_01K46C0WYRXVMFMD2RG4A2ZWQY	\N	pset_01K465NX44JKWR1SAAC359GM0V	php	{"value": "500", "precision": 20}	0	2025-09-03 04:56:03.226+05:30	2025-09-03 04:58:46.315+05:30	2025-09-03 04:58:46.297+05:30	\N	500	\N	\N
price_01K46C0X2TXH09BACVYDQN9SS8	\N	pset_01K465NX44QT6S3ASR8R5D69QZ	php	{"value": "500", "precision": 20}	0	2025-09-03 04:56:03.356+05:30	2025-09-03 04:58:46.317+05:30	2025-09-03 04:58:46.297+05:30	\N	500	\N	\N
price_01K46C0X00GJ8SHFNQ7EQ3AKKK	\N	pset_01K465NX44RAS0X372J4DHVARD	php	{"value": "500", "precision": 20}	0	2025-09-03 04:56:03.266+05:30	2025-09-03 04:58:46.319+05:30	2025-09-03 04:58:46.297+05:30	\N	500	\N	\N
\.


--
-- Data for Name: price_list; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.price_list (id, status, starts_at, ends_at, rules_count, title, description, type, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: price_list_rule; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.price_list_rule (id, price_list_id, created_at, updated_at, deleted_at, value, attribute) FROM stdin;
\.


--
-- Data for Name: price_preference; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.price_preference (id, attribute, value, is_tax_inclusive, created_at, updated_at, deleted_at) FROM stdin;
prpref_01K465NVAQ42229388BYKMQBEY	currency_code	eur	f	2025-09-03 03:05:09.656+05:30	2025-09-03 03:05:09.656+05:30	\N
prpref_01K465NWZ6SWZSQET1B06R6YPE	currency_code	usd	f	2025-09-03 03:05:11.334+05:30	2025-09-03 03:05:11.334+05:30	\N
prpref_01K465NWZMCJ5DWQ60YGVMMKAP	region_id	reg_01K465NWZBB589QBS334WRK4PF	f	2025-09-03 03:05:11.348+05:30	2025-09-03 03:05:11.348+05:30	\N
prpref_01K46BWK4BZ29X4WCYXWRQYA5R	currency_code	php	f	2025-09-03 04:53:42.091+05:30	2025-09-03 04:53:42.091+05:30	\N
prpref_01K46BWK59V922DHWZ20AEX9Z7	region_id	reg_01K46BWK51BRTM8J2035TXGP7Z	f	2025-09-03 04:53:42.121+05:30	2025-09-03 04:53:42.121+05:30	\N
\.


--
-- Data for Name: price_rule; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.price_rule (id, value, priority, price_id, created_at, updated_at, deleted_at, attribute, operator) FROM stdin;
prule_01K465NX13952QNKKADD38EZ3D	reg_01K465NWZBB589QBS334WRK4PF	0	price_01K465NX13NW3SRA7AEEZVFP07	2025-09-03 03:05:11.396+05:30	2025-09-03 03:05:11.396+05:30	\N	region_id	eq
prule_01K465NX13V5XJVZ8SEP6YA9K5	reg_01K465NWZBB589QBS334WRK4PF	0	price_01K465NX13XX1MA71NZWE0ZCJ4	2025-09-03 03:05:11.396+05:30	2025-09-03 03:05:11.396+05:30	\N	region_id	eq
\.


--
-- Data for Name: price_set; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.price_set (id, created_at, updated_at, deleted_at) FROM stdin;
pset_01K465NX13CASJ8S3MJ3RY8NN0	2025-09-03 03:05:11.396+05:30	2025-09-03 03:05:11.396+05:30	\N
pset_01K465NX1352A7Y6X0KEY321EJ	2025-09-03 03:05:11.396+05:30	2025-09-03 03:05:11.396+05:30	\N
pset_01K46AVHDEJX8DTKKBYJN6FNSQ	2025-09-03 04:35:38.99+05:30	2025-09-03 04:35:38.99+05:30	\N
pset_01K46B9PKJ91AES10GCHJEDDH6	2025-09-03 04:43:23.058+05:30	2025-09-03 04:43:23.058+05:30	\N
pset_01K465NX459GE16ZMJ8WJE53MM	2025-09-03 03:05:11.493+05:30	2025-09-03 04:57:23.396+05:30	2025-09-03 04:57:23.395+05:30
pset_01K465NX45E8F05EVJ4CEVES91	2025-09-03 03:05:11.493+05:30	2025-09-03 04:57:23.404+05:30	2025-09-03 04:57:23.395+05:30
pset_01K465NX455B6X7DES3W0CT3DG	2025-09-03 03:05:11.493+05:30	2025-09-03 04:57:23.408+05:30	2025-09-03 04:57:23.395+05:30
pset_01K465NX45MEKVF8PXZ3JRGNV9	2025-09-03 03:05:11.493+05:30	2025-09-03 04:57:23.41+05:30	2025-09-03 04:57:23.395+05:30
pset_01K465NX4410GFGVA840CYXGJW	2025-09-03 03:05:11.493+05:30	2025-09-03 04:57:26.001+05:30	2025-09-03 04:57:26.001+05:30
pset_01K465NX44QCB58J6WYE78AFHK	2025-09-03 03:05:11.493+05:30	2025-09-03 04:57:26.006+05:30	2025-09-03 04:57:26.001+05:30
pset_01K465NX44DCB1BVXBQTS9915P	2025-09-03 03:05:11.493+05:30	2025-09-03 04:57:26.011+05:30	2025-09-03 04:57:26.001+05:30
pset_01K465NX4444HQHPR1JKEHV0F8	2025-09-03 03:05:11.493+05:30	2025-09-03 04:57:26.015+05:30	2025-09-03 04:57:26.001+05:30
pset_01K465NX44M6BG4X08E4GA8HPB	2025-09-03 03:05:11.493+05:30	2025-09-03 04:57:28.782+05:30	2025-09-03 04:57:28.782+05:30
pset_01K465NX444TARD5C6P68061VE	2025-09-03 03:05:11.493+05:30	2025-09-03 04:57:28.789+05:30	2025-09-03 04:57:28.782+05:30
pset_01K465NX44F5KQ2ZJT0A9DA1WS	2025-09-03 03:05:11.493+05:30	2025-09-03 04:57:28.794+05:30	2025-09-03 04:57:28.782+05:30
pset_01K465NX45XEM37BD7JPYVTPRW	2025-09-03 03:05:11.493+05:30	2025-09-03 04:57:28.798+05:30	2025-09-03 04:57:28.782+05:30
pset_01K465NX43N5AYNJ6SRX65Z7ZY	2025-09-03 03:05:11.493+05:30	2025-09-03 04:58:46.297+05:30	2025-09-03 04:58:46.297+05:30
pset_01K465NX433NY32ADJYYSZSKRH	2025-09-03 03:05:11.493+05:30	2025-09-03 04:58:46.303+05:30	2025-09-03 04:58:46.297+05:30
pset_01K465NX43RJEZDA9GXWEWXV6G	2025-09-03 03:05:11.493+05:30	2025-09-03 04:58:46.307+05:30	2025-09-03 04:58:46.297+05:30
pset_01K465NX43FQ5Z8DDHQW27AQNX	2025-09-03 03:05:11.493+05:30	2025-09-03 04:58:46.309+05:30	2025-09-03 04:58:46.297+05:30
pset_01K465NX445E51QVS66ZKGB0F3	2025-09-03 03:05:11.493+05:30	2025-09-03 04:58:46.311+05:30	2025-09-03 04:58:46.297+05:30
pset_01K465NX44JKWR1SAAC359GM0V	2025-09-03 03:05:11.493+05:30	2025-09-03 04:58:46.314+05:30	2025-09-03 04:58:46.297+05:30
pset_01K465NX44QT6S3ASR8R5D69QZ	2025-09-03 03:05:11.493+05:30	2025-09-03 04:58:46.316+05:30	2025-09-03 04:58:46.297+05:30
pset_01K465NX44RAS0X372J4DHVARD	2025-09-03 03:05:11.493+05:30	2025-09-03 04:58:46.318+05:30	2025-09-03 04:58:46.297+05:30
\.


--
-- Data for Name: product; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.product (id, title, handle, subtitle, description, is_giftcard, status, thumbnail, weight, length, height, width, origin_country, hs_code, mid_code, material, collection_id, type_id, discountable, external_id, created_at, updated_at, deleted_at, metadata) FROM stdin;
prod_01K46AVHBWZTYPJJMX5PFWQR1M	Test	test			f	published	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	f	\N	2025-09-03 04:35:38.942+05:30	2025-09-03 04:35:38.942+05:30	\N	\N
prod_01K465NX266PGFTQ8PFSGZS1R3	Medusa Shorts	shorts	\N	Reimagine the feeling of classic shorts. With our cotton shorts, everyday essentials no longer have to be ordinary.	f	published	https://medusa-public-images.s3.eu-west-1.amazonaws.com/shorts-vintage-front.png	400	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	2025-09-03 03:05:11.433+05:30	2025-09-03 04:57:23.379+05:30	2025-09-03 04:57:23.378+05:30	\N
prod_01K465NX26NHGQZJXTREXN0BT0	Medusa Sweatshirt	sweatshirt	\N	Reimagine the feeling of a classic sweatshirt. With our cotton sweatshirt, everyday essentials no longer have to be ordinary.	f	published	https://medusa-public-images.s3.eu-west-1.amazonaws.com/sweatshirt-vintage-front.png	400	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	2025-09-03 03:05:11.432+05:30	2025-09-03 04:57:25.989+05:30	2025-09-03 04:57:25.988+05:30	\N
prod_01K465NX26PX533H2S8NXXM0JE	Medusa Sweatpants	sweatpants	\N	Reimagine the feeling of classic sweatpants. With our cotton sweatpants, everyday essentials no longer have to be ordinary.	f	published	https://medusa-public-images.s3.eu-west-1.amazonaws.com/sweatpants-gray-front.png	400	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	2025-09-03 03:05:11.432+05:30	2025-09-03 04:57:28.777+05:30	2025-09-03 04:57:28.777+05:30	\N
prod_01K465NX26VFWW6C9Y3GJN3K6V	Medusa T-Shirt	t-shirt	\N	Reimagine the feeling of a classic T-shirt. With our cotton T-shirts, everyday essentials no longer have to be ordinary.	f	published	https://medusa-public-images.s3.eu-west-1.amazonaws.com/tee-black-front.png	400	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	\N	2025-09-03 03:05:11.432+05:30	2025-09-03 04:58:46.282+05:30	2025-09-03 04:58:46.282+05:30	\N
\.


--
-- Data for Name: product_category; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.product_category (id, name, description, handle, mpath, is_active, is_internal, rank, parent_category_id, created_at, updated_at, deleted_at, metadata) FROM stdin;
pcat_01K465NX20263MCM5KW46PPEEF	Merch		merch	pcat_01K465NX20263MCM5KW46PPEEF	t	f	3	\N	2025-09-03 03:05:11.425+05:30	2025-09-03 04:11:58.745+05:30	2025-09-03 04:11:58.744+05:30	\N
pcat_01K465NX204NA39KE0AFF1MZCW	Shirts		shirts	pcat_01K465NX204NA39KE0AFF1MZCW	t	f	0	\N	2025-09-03 03:05:11.424+05:30	2025-09-03 04:12:01.966+05:30	2025-09-03 04:12:01.966+05:30	\N
pcat_01K465NX20AMHAFXXHWHHXHGJA	Sweatshirts		sweatshirts	pcat_01K465NX20AMHAFXXHWHHXHGJA	t	f	0	\N	2025-09-03 03:05:11.425+05:30	2025-09-03 04:12:05.37+05:30	2025-09-03 04:12:05.37+05:30	\N
pcat_01K465NX20S33X0DNZ127HRWJ9	Pants		pants	pcat_01K465NX20S33X0DNZ127HRWJ9	t	f	0	\N	2025-09-03 03:05:11.425+05:30	2025-09-03 04:12:08.173+05:30	2025-09-03 04:12:08.173+05:30	\N
pcat_01K469HNTE4VYYVBY1F2Q46MEF	Tablets		tablets	pcat_01K469HNTE4VYYVBY1F2Q46MEF	t	f	0	\N	2025-09-03 04:12:47.246+05:30	2025-09-03 04:12:47.246+05:30	\N	\N
\.


--
-- Data for Name: product_category_product; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.product_category_product (product_id, product_category_id) FROM stdin;
prod_01K465NX26VFWW6C9Y3GJN3K6V	pcat_01K465NX204NA39KE0AFF1MZCW
prod_01K465NX26NHGQZJXTREXN0BT0	pcat_01K465NX20AMHAFXXHWHHXHGJA
prod_01K465NX26PX533H2S8NXXM0JE	pcat_01K465NX20S33X0DNZ127HRWJ9
prod_01K465NX266PGFTQ8PFSGZS1R3	pcat_01K465NX20263MCM5KW46PPEEF
\.


--
-- Data for Name: product_collection; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.product_collection (id, title, handle, metadata, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: product_option; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.product_option (id, title, product_id, metadata, created_at, updated_at, deleted_at) FROM stdin;
opt_01K46AVHBYPSVGWYBDRA7YK1NT	D	prod_01K46AVHBWZTYPJJMX5PFWQR1M	\N	2025-09-03 04:35:38.943+05:30	2025-09-03 04:35:38.943+05:30	\N
opt_01K46B8N0GMYKY62WK1W7P1JPC	M	prod_01K46AVHBWZTYPJJMX5PFWQR1M	\N	2025-09-03 04:42:48.657+05:30	2025-09-03 04:42:48.657+05:30	\N
opt_01K465NX28VD1D5616TG5F73SE	Size	prod_01K465NX266PGFTQ8PFSGZS1R3	\N	2025-09-03 03:05:11.433+05:30	2025-09-03 04:57:23.385+05:30	2025-09-03 04:57:23.378+05:30
opt_01K465NX27D45VV44REDY85X58	Size	prod_01K465NX26NHGQZJXTREXN0BT0	\N	2025-09-03 03:05:11.433+05:30	2025-09-03 04:57:26+05:30	2025-09-03 04:57:25.988+05:30
opt_01K465NX283VJB6WHK1DRYYVGF	Size	prod_01K465NX26PX533H2S8NXXM0JE	\N	2025-09-03 03:05:11.433+05:30	2025-09-03 04:57:28.785+05:30	2025-09-03 04:57:28.777+05:30
opt_01K465NX27V9FY0QV0417JXG1E	Size	prod_01K465NX26VFWW6C9Y3GJN3K6V	\N	2025-09-03 03:05:11.433+05:30	2025-09-03 04:58:46.295+05:30	2025-09-03 04:58:46.282+05:30
opt_01K465NX279WN7ZYRM8QK3HDZA	Color	prod_01K465NX26VFWW6C9Y3GJN3K6V	\N	2025-09-03 03:05:11.433+05:30	2025-09-03 04:58:46.295+05:30	2025-09-03 04:58:46.282+05:30
\.


--
-- Data for Name: product_option_value; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.product_option_value (id, value, option_id, metadata, created_at, updated_at, deleted_at) FROM stdin;
optval_01K46AVHBXGHTQ8N7GC7FRVFXG	Default option value	opt_01K46AVHBYPSVGWYBDRA7YK1NT	\N	2025-09-03 04:35:38.943+05:30	2025-09-03 04:35:38.943+05:30	\N
optval_01K46B8N0GVW0MMDXGTJQNM7ZA	M	opt_01K46B8N0GMYKY62WK1W7P1JPC	\N	2025-09-03 04:42:48.657+05:30	2025-09-03 04:42:48.657+05:30	\N
optval_01K465NX28CC8C2M4TBD6M6N44	S	opt_01K465NX28VD1D5616TG5F73SE	\N	2025-09-03 03:05:11.433+05:30	2025-09-03 04:57:23.397+05:30	2025-09-03 04:57:23.378+05:30
optval_01K465NX28P75QFD321A2RYKFN	M	opt_01K465NX28VD1D5616TG5F73SE	\N	2025-09-03 03:05:11.433+05:30	2025-09-03 04:57:23.397+05:30	2025-09-03 04:57:23.378+05:30
optval_01K465NX284KZ5XQYHPBATAMAV	L	opt_01K465NX28VD1D5616TG5F73SE	\N	2025-09-03 03:05:11.433+05:30	2025-09-03 04:57:23.397+05:30	2025-09-03 04:57:23.378+05:30
optval_01K465NX28ER2RZEXX1687KYQA	XL	opt_01K465NX28VD1D5616TG5F73SE	\N	2025-09-03 03:05:11.433+05:30	2025-09-03 04:57:23.397+05:30	2025-09-03 04:57:23.378+05:30
optval_01K465NX27RBP54B3BPB15T29A	S	opt_01K465NX27D45VV44REDY85X58	\N	2025-09-03 03:05:11.433+05:30	2025-09-03 04:57:26.008+05:30	2025-09-03 04:57:25.988+05:30
optval_01K465NX27R14AXRX2WA6C6ZN5	M	opt_01K465NX27D45VV44REDY85X58	\N	2025-09-03 03:05:11.433+05:30	2025-09-03 04:57:26.008+05:30	2025-09-03 04:57:25.988+05:30
optval_01K465NX27NX2MVB8MP3QGE9FM	L	opt_01K465NX27D45VV44REDY85X58	\N	2025-09-03 03:05:11.433+05:30	2025-09-03 04:57:26.008+05:30	2025-09-03 04:57:25.988+05:30
optval_01K465NX27PFGWDJ9WNVRMSCVP	XL	opt_01K465NX27D45VV44REDY85X58	\N	2025-09-03 03:05:11.433+05:30	2025-09-03 04:57:26.008+05:30	2025-09-03 04:57:25.988+05:30
optval_01K465NX288X4XA1QDBN66TCP5	S	opt_01K465NX283VJB6WHK1DRYYVGF	\N	2025-09-03 03:05:11.433+05:30	2025-09-03 04:57:28.79+05:30	2025-09-03 04:57:28.777+05:30
optval_01K465NX281HM2H2CK2D142KQN	M	opt_01K465NX283VJB6WHK1DRYYVGF	\N	2025-09-03 03:05:11.433+05:30	2025-09-03 04:57:28.79+05:30	2025-09-03 04:57:28.777+05:30
optval_01K465NX28AKCJ43JEQZ33DG9W	L	opt_01K465NX283VJB6WHK1DRYYVGF	\N	2025-09-03 03:05:11.433+05:30	2025-09-03 04:57:28.79+05:30	2025-09-03 04:57:28.777+05:30
optval_01K465NX28BQJQSW4XTHR0Z59G	XL	opt_01K465NX283VJB6WHK1DRYYVGF	\N	2025-09-03 03:05:11.433+05:30	2025-09-03 04:57:28.791+05:30	2025-09-03 04:57:28.777+05:30
optval_01K465NX27QMF6DMDX3R8Y0H5Y	S	opt_01K465NX27V9FY0QV0417JXG1E	\N	2025-09-03 03:05:11.433+05:30	2025-09-03 04:58:46.3+05:30	2025-09-03 04:58:46.282+05:30
optval_01K465NX27GY7D0RBPPBP55606	M	opt_01K465NX27V9FY0QV0417JXG1E	\N	2025-09-03 03:05:11.433+05:30	2025-09-03 04:58:46.3+05:30	2025-09-03 04:58:46.282+05:30
optval_01K465NX27B1RSHRRGPKHSD2F1	L	opt_01K465NX27V9FY0QV0417JXG1E	\N	2025-09-03 03:05:11.433+05:30	2025-09-03 04:58:46.3+05:30	2025-09-03 04:58:46.282+05:30
optval_01K465NX2726GK9BXN6PFJTY94	XL	opt_01K465NX27V9FY0QV0417JXG1E	\N	2025-09-03 03:05:11.433+05:30	2025-09-03 04:58:46.3+05:30	2025-09-03 04:58:46.282+05:30
optval_01K465NX27A3Q0T0P9115D88DT	Black	opt_01K465NX279WN7ZYRM8QK3HDZA	\N	2025-09-03 03:05:11.433+05:30	2025-09-03 04:58:46.3+05:30	2025-09-03 04:58:46.282+05:30
optval_01K465NX27Y0CJ6GAKXN77TTPP	White	opt_01K465NX279WN7ZYRM8QK3HDZA	\N	2025-09-03 03:05:11.433+05:30	2025-09-03 04:58:46.3+05:30	2025-09-03 04:58:46.282+05:30
\.


--
-- Data for Name: product_sales_channel; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.product_sales_channel (product_id, sales_channel_id, id, created_at, updated_at, deleted_at) FROM stdin;
prod_01K46AVHBWZTYPJJMX5PFWQR1M	sc_01K465NVAAFMSJ0RGP5VCKEPVH	prodsc_01K46B576V290HB5D1DV96HSBB	2025-09-03 04:35:38.95686+05:30	2025-09-03 04:40:56.214+05:30	\N
prod_01K465NX266PGFTQ8PFSGZS1R3	sc_01K465NVAAFMSJ0RGP5VCKEPVH	prodsc_01K465NX2KPZH860CHDHJKWGHF	2025-09-03 03:05:11.44293+05:30	2025-09-03 04:57:23.38+05:30	2025-09-03 04:57:23.379+05:30
prod_01K465NX26NHGQZJXTREXN0BT0	sc_01K465NVAAFMSJ0RGP5VCKEPVH	prodsc_01K465NX2KGHVFF2EZQWMEH6AY	2025-09-03 03:05:11.44293+05:30	2025-09-03 04:57:25.994+05:30	2025-09-03 04:57:25.994+05:30
prod_01K465NX26PX533H2S8NXXM0JE	sc_01K465NVAAFMSJ0RGP5VCKEPVH	prodsc_01K465NX2KC70TV2FFG8S9T53Q	2025-09-03 03:05:11.44293+05:30	2025-09-03 04:57:28.779+05:30	2025-09-03 04:57:28.779+05:30
prod_01K465NX26VFWW6C9Y3GJN3K6V	sc_01K465NVAAFMSJ0RGP5VCKEPVH	prodsc_01K465NX2KBEVRYJEA834AJN26	2025-09-03 03:05:11.44293+05:30	2025-09-03 04:58:46.286+05:30	2025-09-03 04:58:46.286+05:30
\.


--
-- Data for Name: product_shipping_profile; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.product_shipping_profile (product_id, shipping_profile_id, id, created_at, updated_at, deleted_at) FROM stdin;
prod_01K46AVHBWZTYPJJMX5PFWQR1M	sp_01K465NSMNCMB3KTQC20148JAW	prodsp_01K46B50J5VCZXE7HSE5V5D98X	2025-09-03 04:40:49.413666+05:30	2025-09-03 04:40:49.413666+05:30	\N
prod_01K465NX266PGFTQ8PFSGZS1R3	sp_01K465NSMNCMB3KTQC20148JAW	prodsp_01K465NX2T2W5P0XJ6D0GSME3T	2025-09-03 03:05:11.450025+05:30	2025-09-03 04:57:23.382+05:30	2025-09-03 04:57:23.381+05:30
prod_01K465NX26NHGQZJXTREXN0BT0	sp_01K465NSMNCMB3KTQC20148JAW	prodsp_01K465NX2T23H32HHYPPCDCS7P	2025-09-03 03:05:11.450025+05:30	2025-09-03 04:57:25.995+05:30	2025-09-03 04:57:25.995+05:30
prod_01K465NX26PX533H2S8NXXM0JE	sp_01K465NSMNCMB3KTQC20148JAW	prodsp_01K465NX2TZB41FC0ZAH92FAW9	2025-09-03 03:05:11.450025+05:30	2025-09-03 04:57:28.778+05:30	2025-09-03 04:57:28.778+05:30
prod_01K465NX26VFWW6C9Y3GJN3K6V	sp_01K465NSMNCMB3KTQC20148JAW	prodsp_01K465NX2TBG8VN6SAHDKX7C1F	2025-09-03 03:05:11.450025+05:30	2025-09-03 04:58:46.287+05:30	2025-09-03 04:58:46.287+05:30
\.


--
-- Data for Name: product_tag; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.product_tag (id, value, metadata, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: product_tags; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.product_tags (product_id, product_tag_id) FROM stdin;
\.


--
-- Data for Name: product_type; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.product_type (id, value, metadata, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: product_variant; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.product_variant (id, title, sku, barcode, ean, upc, allow_backorder, manage_inventory, hs_code, origin_country, mid_code, material, weight, length, height, width, metadata, variant_rank, product_id, created_at, updated_at, deleted_at) FROM stdin;
variant_01K465NX36A3M4SJ7RCJ0V7M70	S	SWEATPANTS-S	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01K465NX26PX533H2S8NXXM0JE	2025-09-03 03:05:11.463+05:30	2025-09-03 04:57:28.785+05:30	2025-09-03 04:57:28.777+05:30
variant_01K465NX361ZJ3MG2BQBSH0JYD	XL	SWEATPANTS-XL	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01K465NX26PX533H2S8NXXM0JE	2025-09-03 03:05:11.463+05:30	2025-09-03 04:57:28.785+05:30	2025-09-03 04:57:28.777+05:30
variant_01K465NX368SB78DW9XFK20J4Z	M	SWEATPANTS-M	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01K465NX26PX533H2S8NXXM0JE	2025-09-03 03:05:11.463+05:30	2025-09-03 04:57:28.785+05:30	2025-09-03 04:57:28.777+05:30
variant_01K465NX36SYCRKBDHHF7ZMPZT	L	SWEATPANTS-L	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01K465NX26PX533H2S8NXXM0JE	2025-09-03 03:05:11.463+05:30	2025-09-03 04:57:28.785+05:30	2025-09-03 04:57:28.777+05:30
variant_01K465NX36820TWHZARBXAKJAS	L / White	SHIRT-L-WHITE	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01K465NX26VFWW6C9Y3GJN3K6V	2025-09-03 03:05:11.463+05:30	2025-09-03 04:58:46.294+05:30	2025-09-03 04:58:46.282+05:30
variant_01K465NX36F7H5J3QGSSX4WSFA	L / Black	SHIRT-L-BLACK	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01K465NX26VFWW6C9Y3GJN3K6V	2025-09-03 03:05:11.463+05:30	2025-09-03 04:58:46.294+05:30	2025-09-03 04:58:46.282+05:30
variant_01K465NX36J0TSYNBTBJFK3F8M	XL / White	SHIRT-XL-WHITE	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01K465NX26VFWW6C9Y3GJN3K6V	2025-09-03 03:05:11.463+05:30	2025-09-03 04:58:46.294+05:30	2025-09-03 04:58:46.282+05:30
variant_01K465NX36QVW4VT9ZBR1WEYPA	M / Black	SHIRT-M-BLACK	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01K465NX26VFWW6C9Y3GJN3K6V	2025-09-03 03:05:11.463+05:30	2025-09-03 04:58:46.294+05:30	2025-09-03 04:58:46.282+05:30
variant_01K46B9PJPN21CW9KVSXV5PDJ7	Test	\N	\N	\N	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01K46AVHBWZTYPJJMX5PFWQR1M	2025-09-03 04:43:23.03+05:30	2025-09-03 04:43:23.03+05:30	\N
variant_01K46AVHD0MGCTKZ4NMHTMQT8Z	Default variant	\N	\N	\N	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01K46AVHBWZTYPJJMX5PFWQR1M	2025-09-03 04:35:38.976+05:30	2025-09-03 04:35:38.976+05:30	\N
variant_01K465NX37E3QYA3H221395ZQJ	XL	SHORTS-XL	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01K465NX266PGFTQ8PFSGZS1R3	2025-09-03 03:05:11.463+05:30	2025-09-03 04:57:23.385+05:30	2025-09-03 04:57:23.378+05:30
variant_01K465NX3659TBXRDK2MZ3S3QJ	S	SHORTS-S	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01K465NX266PGFTQ8PFSGZS1R3	2025-09-03 03:05:11.463+05:30	2025-09-03 04:57:23.385+05:30	2025-09-03 04:57:23.378+05:30
variant_01K465NX36ZFA4H7DCEXFJ0WN4	M	SHORTS-M	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01K465NX266PGFTQ8PFSGZS1R3	2025-09-03 03:05:11.463+05:30	2025-09-03 04:57:23.385+05:30	2025-09-03 04:57:23.378+05:30
variant_01K465NX37MHFAWV23YEA6MZKQ	L	SHORTS-L	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01K465NX266PGFTQ8PFSGZS1R3	2025-09-03 03:05:11.463+05:30	2025-09-03 04:57:23.385+05:30	2025-09-03 04:57:23.378+05:30
variant_01K465NX360NFH1QW01RGA1E2V	M	SWEATSHIRT-M	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01K465NX26NHGQZJXTREXN0BT0	2025-09-03 03:05:11.463+05:30	2025-09-03 04:57:25.999+05:30	2025-09-03 04:57:25.988+05:30
variant_01K465NX36A30RMQB6TA39EDQG	S	SWEATSHIRT-S	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01K465NX26NHGQZJXTREXN0BT0	2025-09-03 03:05:11.463+05:30	2025-09-03 04:57:26+05:30	2025-09-03 04:57:25.988+05:30
variant_01K465NX361J0MV9ZSWEGZFE6Z	L	SWEATSHIRT-L	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01K465NX26NHGQZJXTREXN0BT0	2025-09-03 03:05:11.463+05:30	2025-09-03 04:57:26+05:30	2025-09-03 04:57:25.988+05:30
variant_01K465NX368GRNXE7X3NJHKZ2C	XL	SWEATSHIRT-XL	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01K465NX26NHGQZJXTREXN0BT0	2025-09-03 03:05:11.463+05:30	2025-09-03 04:57:26+05:30	2025-09-03 04:57:25.988+05:30
variant_01K465NX361YN25Q9E7EKG104J	S / Black	SHIRT-S-BLACK	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01K465NX26VFWW6C9Y3GJN3K6V	2025-09-03 03:05:11.463+05:30	2025-09-03 04:58:46.294+05:30	2025-09-03 04:58:46.282+05:30
variant_01K465NX36B5Q6THP8VT05A2CK	S / White	SHIRT-S-WHITE	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01K465NX26VFWW6C9Y3GJN3K6V	2025-09-03 03:05:11.463+05:30	2025-09-03 04:58:46.294+05:30	2025-09-03 04:58:46.282+05:30
variant_01K465NX366HV3KMEAC710RB08	M / White	SHIRT-M-WHITE	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01K465NX26VFWW6C9Y3GJN3K6V	2025-09-03 03:05:11.463+05:30	2025-09-03 04:58:46.294+05:30	2025-09-03 04:58:46.282+05:30
variant_01K465NX362NQCDSWGVZY683TD	XL / Black	SHIRT-XL-BLACK	\N	\N	\N	f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01K465NX26VFWW6C9Y3GJN3K6V	2025-09-03 03:05:11.463+05:30	2025-09-03 04:58:46.294+05:30	2025-09-03 04:58:46.282+05:30
\.


--
-- Data for Name: product_variant_inventory_item; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.product_variant_inventory_item (variant_id, inventory_item_id, id, required_quantity, created_at, updated_at, deleted_at) FROM stdin;
variant_01K465NX3659TBXRDK2MZ3S3QJ	iitem_01K465NX3KX2Y3P7ZBKZR2J82M	pvitem_01K465NX3XZHYR2ZHAYSVF9Y7Z	1	2025-09-03 03:05:11.485041+05:30	2025-09-03 04:57:23.367+05:30	2025-09-03 04:57:23.366+05:30
variant_01K465NX36ZFA4H7DCEXFJ0WN4	iitem_01K465NX3MSRWD47J6GAMEEE4V	pvitem_01K465NX3XE94V2GHYGGT0QC77	1	2025-09-03 03:05:11.485041+05:30	2025-09-03 04:57:23.367+05:30	2025-09-03 04:57:23.366+05:30
variant_01K465NX37MHFAWV23YEA6MZKQ	iitem_01K465NX3M4RT8CAEXJ1QKZ7Z2	pvitem_01K465NX3XE7N7DGEJMEY6DN5P	1	2025-09-03 03:05:11.485041+05:30	2025-09-03 04:57:23.367+05:30	2025-09-03 04:57:23.366+05:30
variant_01K465NX37E3QYA3H221395ZQJ	iitem_01K465NX3MXW0YJG2CMDP73AN7	pvitem_01K465NX3XJV34DFCVV6T9Z0SB	1	2025-09-03 03:05:11.485041+05:30	2025-09-03 04:57:23.367+05:30	2025-09-03 04:57:23.366+05:30
variant_01K465NX36A30RMQB6TA39EDQG	iitem_01K465NX3K3V01QEXHAZA3XRPF	pvitem_01K465NX3XEQ2AQG9VG2V4BT9K	1	2025-09-03 03:05:11.485041+05:30	2025-09-03 04:57:25.98+05:30	2025-09-03 04:57:25.98+05:30
variant_01K465NX360NFH1QW01RGA1E2V	iitem_01K465NX3KZQAGR8TJD8KM2MJ6	pvitem_01K465NX3XKQQ7KSNV3A4WRZSG	1	2025-09-03 03:05:11.485041+05:30	2025-09-03 04:57:25.98+05:30	2025-09-03 04:57:25.98+05:30
variant_01K465NX361J0MV9ZSWEGZFE6Z	iitem_01K465NX3K92G4FED4ENTQQBV0	pvitem_01K465NX3XZ6YY64G925QH3M9K	1	2025-09-03 03:05:11.485041+05:30	2025-09-03 04:57:25.98+05:30	2025-09-03 04:57:25.98+05:30
variant_01K465NX368GRNXE7X3NJHKZ2C	iitem_01K465NX3KGGW9PBGMA6QZ8639	pvitem_01K465NX3X61G38F9R3HMC8T6D	1	2025-09-03 03:05:11.485041+05:30	2025-09-03 04:57:25.98+05:30	2025-09-03 04:57:25.98+05:30
variant_01K465NX36A3M4SJ7RCJ0V7M70	iitem_01K465NX3K3JE3ZGA8N1JEPAN4	pvitem_01K465NX3X94XJ56J6HF2CDYHJ	1	2025-09-03 03:05:11.485041+05:30	2025-09-03 04:57:28.768+05:30	2025-09-03 04:57:28.768+05:30
variant_01K465NX368SB78DW9XFK20J4Z	iitem_01K465NX3KDM01XEXK1CDXT1S1	pvitem_01K465NX3X999T5Z1STMFC10C1	1	2025-09-03 03:05:11.485041+05:30	2025-09-03 04:57:28.769+05:30	2025-09-03 04:57:28.768+05:30
variant_01K465NX36SYCRKBDHHF7ZMPZT	iitem_01K465NX3K0TTEHQD5MPKTN77K	pvitem_01K465NX3XEPXHVVGKT64J20A5	1	2025-09-03 03:05:11.485041+05:30	2025-09-03 04:57:28.769+05:30	2025-09-03 04:57:28.768+05:30
variant_01K465NX361ZJ3MG2BQBSH0JYD	iitem_01K465NX3KFA9HZKP6DTS54DVM	pvitem_01K465NX3X5QZJ30PQE8V3BB8S	1	2025-09-03 03:05:11.485041+05:30	2025-09-03 04:57:28.769+05:30	2025-09-03 04:57:28.768+05:30
variant_01K465NX361YN25Q9E7EKG104J	iitem_01K465NX3KBWKB951V07M21BEF	pvitem_01K465NX3XB55C7WY2AXHD6H94	1	2025-09-03 03:05:11.485041+05:30	2025-09-03 04:58:46.253+05:30	2025-09-03 04:58:46.252+05:30
variant_01K465NX36B5Q6THP8VT05A2CK	iitem_01K465NX3KKGH4WP9ZWEVFEP0Z	pvitem_01K465NX3X8S0QJWAY2S6PQEAY	1	2025-09-03 03:05:11.485041+05:30	2025-09-03 04:58:46.253+05:30	2025-09-03 04:58:46.252+05:30
variant_01K465NX36QVW4VT9ZBR1WEYPA	iitem_01K465NX3KN80Z3BCCYJFH27BP	pvitem_01K465NX3X86HM00XAX42FBGHK	1	2025-09-03 03:05:11.485041+05:30	2025-09-03 04:58:46.253+05:30	2025-09-03 04:58:46.252+05:30
variant_01K465NX366HV3KMEAC710RB08	iitem_01K465NX3KPDDV32DQZK5TAE5M	pvitem_01K465NX3XNN2EAFTTMB600ASN	1	2025-09-03 03:05:11.485041+05:30	2025-09-03 04:58:46.253+05:30	2025-09-03 04:58:46.252+05:30
variant_01K465NX36F7H5J3QGSSX4WSFA	iitem_01K465NX3K5H8B3VZ9R15WX93C	pvitem_01K465NX3X44J2RAF33YHH57J9	1	2025-09-03 03:05:11.485041+05:30	2025-09-03 04:58:46.253+05:30	2025-09-03 04:58:46.252+05:30
variant_01K465NX36820TWHZARBXAKJAS	iitem_01K465NX3KZKX8H25Q1EWVPZC6	pvitem_01K465NX3XNKTAKVSYS2FQ52Y7	1	2025-09-03 03:05:11.485041+05:30	2025-09-03 04:58:46.253+05:30	2025-09-03 04:58:46.252+05:30
variant_01K465NX362NQCDSWGVZY683TD	iitem_01K465NX3K9RWBBSYGQ8SGS1SD	pvitem_01K465NX3XQ022PD8AVBGBRMY3	1	2025-09-03 03:05:11.485041+05:30	2025-09-03 04:58:46.253+05:30	2025-09-03 04:58:46.252+05:30
variant_01K465NX36J0TSYNBTBJFK3F8M	iitem_01K465NX3KJHWDDPGH9ZVGAYQX	pvitem_01K465NX3X2SE0CYAN9HCW7YKS	1	2025-09-03 03:05:11.485041+05:30	2025-09-03 04:58:46.253+05:30	2025-09-03 04:58:46.252+05:30
\.


--
-- Data for Name: product_variant_option; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.product_variant_option (variant_id, option_value_id) FROM stdin;
variant_01K465NX361YN25Q9E7EKG104J	optval_01K465NX27QMF6DMDX3R8Y0H5Y
variant_01K465NX361YN25Q9E7EKG104J	optval_01K465NX27A3Q0T0P9115D88DT
variant_01K465NX36B5Q6THP8VT05A2CK	optval_01K465NX27QMF6DMDX3R8Y0H5Y
variant_01K465NX36B5Q6THP8VT05A2CK	optval_01K465NX27Y0CJ6GAKXN77TTPP
variant_01K465NX36QVW4VT9ZBR1WEYPA	optval_01K465NX27GY7D0RBPPBP55606
variant_01K465NX36QVW4VT9ZBR1WEYPA	optval_01K465NX27A3Q0T0P9115D88DT
variant_01K465NX366HV3KMEAC710RB08	optval_01K465NX27GY7D0RBPPBP55606
variant_01K465NX366HV3KMEAC710RB08	optval_01K465NX27Y0CJ6GAKXN77TTPP
variant_01K465NX36F7H5J3QGSSX4WSFA	optval_01K465NX27B1RSHRRGPKHSD2F1
variant_01K465NX36F7H5J3QGSSX4WSFA	optval_01K465NX27A3Q0T0P9115D88DT
variant_01K465NX36820TWHZARBXAKJAS	optval_01K465NX27B1RSHRRGPKHSD2F1
variant_01K465NX36820TWHZARBXAKJAS	optval_01K465NX27Y0CJ6GAKXN77TTPP
variant_01K465NX362NQCDSWGVZY683TD	optval_01K465NX2726GK9BXN6PFJTY94
variant_01K465NX362NQCDSWGVZY683TD	optval_01K465NX27A3Q0T0P9115D88DT
variant_01K465NX36J0TSYNBTBJFK3F8M	optval_01K465NX2726GK9BXN6PFJTY94
variant_01K465NX36J0TSYNBTBJFK3F8M	optval_01K465NX27Y0CJ6GAKXN77TTPP
variant_01K465NX36A30RMQB6TA39EDQG	optval_01K465NX27RBP54B3BPB15T29A
variant_01K465NX360NFH1QW01RGA1E2V	optval_01K465NX27R14AXRX2WA6C6ZN5
variant_01K465NX361J0MV9ZSWEGZFE6Z	optval_01K465NX27NX2MVB8MP3QGE9FM
variant_01K465NX368GRNXE7X3NJHKZ2C	optval_01K465NX27PFGWDJ9WNVRMSCVP
variant_01K465NX36A3M4SJ7RCJ0V7M70	optval_01K465NX288X4XA1QDBN66TCP5
variant_01K465NX368SB78DW9XFK20J4Z	optval_01K465NX281HM2H2CK2D142KQN
variant_01K465NX36SYCRKBDHHF7ZMPZT	optval_01K465NX28AKCJ43JEQZ33DG9W
variant_01K465NX361ZJ3MG2BQBSH0JYD	optval_01K465NX28BQJQSW4XTHR0Z59G
variant_01K465NX3659TBXRDK2MZ3S3QJ	optval_01K465NX28CC8C2M4TBD6M6N44
variant_01K465NX36ZFA4H7DCEXFJ0WN4	optval_01K465NX28P75QFD321A2RYKFN
variant_01K465NX37MHFAWV23YEA6MZKQ	optval_01K465NX284KZ5XQYHPBATAMAV
variant_01K465NX37E3QYA3H221395ZQJ	optval_01K465NX28ER2RZEXX1687KYQA
variant_01K46AVHD0MGCTKZ4NMHTMQT8Z	optval_01K46AVHBXGHTQ8N7GC7FRVFXG
variant_01K46B9PJPN21CW9KVSXV5PDJ7	optval_01K46AVHBXGHTQ8N7GC7FRVFXG
variant_01K46B9PJPN21CW9KVSXV5PDJ7	optval_01K46B8N0GVW0MMDXGTJQNM7ZA
\.


--
-- Data for Name: product_variant_price_set; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.product_variant_price_set (variant_id, price_set_id, id, created_at, updated_at, deleted_at) FROM stdin;
variant_01K46AVHD0MGCTKZ4NMHTMQT8Z	pset_01K46AVHDEJX8DTKKBYJN6FNSQ	pvps_01K46AVHDSMQW9K3J0D1V6QQ7C	2025-09-03 04:35:39.001164+05:30	2025-09-03 04:35:39.001164+05:30	\N
variant_01K46B9PJPN21CW9KVSXV5PDJ7	pset_01K46B9PKJ91AES10GCHJEDDH6	pvps_01K46B9PM8VE2RX2CZHGVRJ1GT	2025-09-03 04:43:23.080624+05:30	2025-09-03 04:43:23.080624+05:30	\N
variant_01K465NX3659TBXRDK2MZ3S3QJ	pset_01K465NX459GE16ZMJ8WJE53MM	pvps_01K465NX4NSXPFACW1ACY2F0D0	2025-09-03 03:05:11.509114+05:30	2025-09-03 04:57:23.386+05:30	2025-09-03 04:57:23.385+05:30
variant_01K465NX36ZFA4H7DCEXFJ0WN4	pset_01K465NX45E8F05EVJ4CEVES91	pvps_01K465NX4NFF1V4HMRGYC04SPP	2025-09-03 03:05:11.509114+05:30	2025-09-03 04:57:23.386+05:30	2025-09-03 04:57:23.385+05:30
variant_01K465NX37MHFAWV23YEA6MZKQ	pset_01K465NX455B6X7DES3W0CT3DG	pvps_01K465NX4NH4VAZAXG1MW99ZXA	2025-09-03 03:05:11.509114+05:30	2025-09-03 04:57:23.386+05:30	2025-09-03 04:57:23.385+05:30
variant_01K465NX37E3QYA3H221395ZQJ	pset_01K465NX45MEKVF8PXZ3JRGNV9	pvps_01K465NX4NP6HEZR7AWFQVW1AD	2025-09-03 03:05:11.509114+05:30	2025-09-03 04:57:23.386+05:30	2025-09-03 04:57:23.385+05:30
variant_01K465NX36A30RMQB6TA39EDQG	pset_01K465NX4410GFGVA840CYXGJW	pvps_01K465NX4NX5HBM3H45V4N6J3Z	2025-09-03 03:05:11.509114+05:30	2025-09-03 04:57:25.99+05:30	2025-09-03 04:57:25.99+05:30
variant_01K465NX360NFH1QW01RGA1E2V	pset_01K465NX44QCB58J6WYE78AFHK	pvps_01K465NX4NCKC4SKJ9BADQ2ME8	2025-09-03 03:05:11.509114+05:30	2025-09-03 04:57:25.99+05:30	2025-09-03 04:57:25.99+05:30
variant_01K465NX361J0MV9ZSWEGZFE6Z	pset_01K465NX44DCB1BVXBQTS9915P	pvps_01K465NX4NR5K28WJGKEPV3SYB	2025-09-03 03:05:11.509114+05:30	2025-09-03 04:57:25.99+05:30	2025-09-03 04:57:25.99+05:30
variant_01K465NX368GRNXE7X3NJHKZ2C	pset_01K465NX4444HQHPR1JKEHV0F8	pvps_01K465NX4N74GNBE39ZMET5TVV	2025-09-03 03:05:11.509114+05:30	2025-09-03 04:57:25.99+05:30	2025-09-03 04:57:25.99+05:30
variant_01K465NX36A3M4SJ7RCJ0V7M70	pset_01K465NX44M6BG4X08E4GA8HPB	pvps_01K465NX4NS4N87SMZY6AK4R60	2025-09-03 03:05:11.509114+05:30	2025-09-03 04:57:28.776+05:30	2025-09-03 04:57:28.776+05:30
variant_01K465NX368SB78DW9XFK20J4Z	pset_01K465NX444TARD5C6P68061VE	pvps_01K465NX4NAWDMCA8ZVEJ3NMQE	2025-09-03 03:05:11.509114+05:30	2025-09-03 04:57:28.776+05:30	2025-09-03 04:57:28.776+05:30
variant_01K465NX36SYCRKBDHHF7ZMPZT	pset_01K465NX44F5KQ2ZJT0A9DA1WS	pvps_01K465NX4NFNEZZPZX0YZVB1XP	2025-09-03 03:05:11.509114+05:30	2025-09-03 04:57:28.776+05:30	2025-09-03 04:57:28.776+05:30
variant_01K465NX361ZJ3MG2BQBSH0JYD	pset_01K465NX45XEM37BD7JPYVTPRW	pvps_01K465NX4NFD00Q09PTT7GYMHP	2025-09-03 03:05:11.509114+05:30	2025-09-03 04:57:28.776+05:30	2025-09-03 04:57:28.776+05:30
variant_01K465NX361YN25Q9E7EKG104J	pset_01K465NX43N5AYNJ6SRX65Z7ZY	pvps_01K465NX4NMSMBQ8QSJT392485	2025-09-03 03:05:11.509114+05:30	2025-09-03 04:58:46.285+05:30	2025-09-03 04:58:46.284+05:30
variant_01K465NX36B5Q6THP8VT05A2CK	pset_01K465NX433NY32ADJYYSZSKRH	pvps_01K465NX4NBG6Y3XFSXE401PRZ	2025-09-03 03:05:11.509114+05:30	2025-09-03 04:58:46.285+05:30	2025-09-03 04:58:46.284+05:30
variant_01K465NX36QVW4VT9ZBR1WEYPA	pset_01K465NX43RJEZDA9GXWEWXV6G	pvps_01K465NX4NRFNV6PSS2T9S6XTB	2025-09-03 03:05:11.509114+05:30	2025-09-03 04:58:46.285+05:30	2025-09-03 04:58:46.284+05:30
variant_01K465NX366HV3KMEAC710RB08	pset_01K465NX43FQ5Z8DDHQW27AQNX	pvps_01K465NX4N1ZSBGAFBMRQPHVDY	2025-09-03 03:05:11.509114+05:30	2025-09-03 04:58:46.285+05:30	2025-09-03 04:58:46.284+05:30
variant_01K465NX36F7H5J3QGSSX4WSFA	pset_01K465NX445E51QVS66ZKGB0F3	pvps_01K465NX4N9PWC8RS3TRQE4HP4	2025-09-03 03:05:11.509114+05:30	2025-09-03 04:58:46.285+05:30	2025-09-03 04:58:46.284+05:30
variant_01K465NX36820TWHZARBXAKJAS	pset_01K465NX44JKWR1SAAC359GM0V	pvps_01K465NX4N3SJ1P6DVRTJY0H4H	2025-09-03 03:05:11.509114+05:30	2025-09-03 04:58:46.285+05:30	2025-09-03 04:58:46.284+05:30
variant_01K465NX362NQCDSWGVZY683TD	pset_01K465NX44QT6S3ASR8R5D69QZ	pvps_01K465NX4NAEMRZY2RCQ4H19WF	2025-09-03 03:05:11.509114+05:30	2025-09-03 04:58:46.285+05:30	2025-09-03 04:58:46.284+05:30
variant_01K465NX36J0TSYNBTBJFK3F8M	pset_01K465NX44RAS0X372J4DHVARD	pvps_01K465NX4N1D31R9D6NYQKSZ4V	2025-09-03 03:05:11.509114+05:30	2025-09-03 04:58:46.285+05:30	2025-09-03 04:58:46.284+05:30
\.


--
-- Data for Name: promotion; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.promotion (id, code, campaign_id, is_automatic, type, created_at, updated_at, deleted_at, status, is_tax_inclusive) FROM stdin;
\.


--
-- Data for Name: promotion_application_method; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.promotion_application_method (id, value, raw_value, max_quantity, apply_to_quantity, buy_rules_min_quantity, type, target_type, allocation, promotion_id, created_at, updated_at, deleted_at, currency_code) FROM stdin;
\.


--
-- Data for Name: promotion_campaign; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.promotion_campaign (id, name, description, campaign_identifier, starts_at, ends_at, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: promotion_campaign_budget; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.promotion_campaign_budget (id, type, campaign_id, "limit", raw_limit, used, raw_used, created_at, updated_at, deleted_at, currency_code) FROM stdin;
\.


--
-- Data for Name: promotion_promotion_rule; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.promotion_promotion_rule (promotion_id, promotion_rule_id) FROM stdin;
\.


--
-- Data for Name: promotion_rule; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.promotion_rule (id, description, attribute, operator, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: promotion_rule_value; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.promotion_rule_value (id, promotion_rule_id, value, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: provider_identity; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.provider_identity (id, entity_id, provider, auth_identity_id, user_metadata, provider_metadata, created_at, updated_at, deleted_at) FROM stdin;
01K4699ZP4K4W49MBVWGY4360B	mukulyadav49@gmail.com	emailpass	authid_01K4699ZP44BNNFQAR83G0PD4N	\N	{"password": "c2NyeXB0AA8AAAAIAAAAAeBXK8pshaYMXQCSYvxWRShKFHO2ZreruWdn+GE2n0jt32CIqR6p3em6/7b1yZjozGzq9FZ/uWjaiNA4VAsMkwtbQWR8ll/fg73g8lvLEnGA"}	2025-09-03 04:08:35.204+05:30	2025-09-03 04:08:35.204+05:30	\N
01K46A3BATSPVRB1M7ATT3TM1J	mk24x7@gmail.com	emailpass	authid_01K46A3BATMFQ8REM2QGHTE64G	\N	{"password": "c2NyeXB0AA8AAAAIAAAAASS8NW15MEV2srfdu4Q1X3Z7qEhk7iEaL2IUlihoA/d3vaSsDaioX3zER8tllgfr2qNyNgdHb9hg+LA9+pTYrFw6bI3oziFcNM07kVWR+2zg"}	2025-09-03 04:22:26.331+05:30	2025-09-03 04:22:26.331+05:30	\N
\.


--
-- Data for Name: publishable_api_key_sales_channel; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.publishable_api_key_sales_channel (publishable_key_id, sales_channel_id, id, created_at, updated_at, deleted_at) FROM stdin;
apk_01K465NX1NM4WYMK1TC7WN4VMQ	sc_01K465NVAAFMSJ0RGP5VCKEPVH	pksc_01K465NX1SCM2EYBRBHXAZSV3K	2025-09-03 03:05:11.417883+05:30	2025-09-03 03:05:11.417883+05:30	\N
\.


--
-- Data for Name: refund; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.refund (id, amount, raw_amount, payment_id, created_at, updated_at, deleted_at, created_by, metadata, refund_reason_id, note) FROM stdin;
\.


--
-- Data for Name: refund_reason; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.refund_reason (id, label, description, metadata, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: region; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.region (id, name, currency_code, metadata, created_at, updated_at, deleted_at, automatic_taxes) FROM stdin;
reg_01K465NWZBB589QBS334WRK4PF	Europe	eur	\N	2025-09-03 03:05:11.341+05:30	2025-09-03 04:53:42.099+05:30	2025-09-03 04:53:42.098+05:30	t
reg_01K46BWK51BRTM8J2035TXGP7Z	Philippines	php	\N	2025-09-03 04:53:42.115+05:30	2025-09-03 04:53:42.115+05:30	\N	t
\.


--
-- Data for Name: region_country; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.region_country (iso_2, iso_3, num_code, name, display_name, region_id, metadata, created_at, updated_at, deleted_at) FROM stdin;
af	afg	004	AFGHANISTAN	Afghanistan	\N	\N	2025-09-03 03:05:07.447+05:30	2025-09-03 03:05:07.447+05:30	\N
al	alb	008	ALBANIA	Albania	\N	\N	2025-09-03 03:05:07.447+05:30	2025-09-03 03:05:07.447+05:30	\N
dz	dza	012	ALGERIA	Algeria	\N	\N	2025-09-03 03:05:07.447+05:30	2025-09-03 03:05:07.447+05:30	\N
as	asm	016	AMERICAN SAMOA	American Samoa	\N	\N	2025-09-03 03:05:07.447+05:30	2025-09-03 03:05:07.447+05:30	\N
ad	and	020	ANDORRA	Andorra	\N	\N	2025-09-03 03:05:07.447+05:30	2025-09-03 03:05:07.447+05:30	\N
ao	ago	024	ANGOLA	Angola	\N	\N	2025-09-03 03:05:07.447+05:30	2025-09-03 03:05:07.447+05:30	\N
ai	aia	660	ANGUILLA	Anguilla	\N	\N	2025-09-03 03:05:07.447+05:30	2025-09-03 03:05:07.447+05:30	\N
aq	ata	010	ANTARCTICA	Antarctica	\N	\N	2025-09-03 03:05:07.447+05:30	2025-09-03 03:05:07.447+05:30	\N
ag	atg	028	ANTIGUA AND BARBUDA	Antigua and Barbuda	\N	\N	2025-09-03 03:05:07.447+05:30	2025-09-03 03:05:07.447+05:30	\N
ar	arg	032	ARGENTINA	Argentina	\N	\N	2025-09-03 03:05:07.447+05:30	2025-09-03 03:05:07.447+05:30	\N
am	arm	051	ARMENIA	Armenia	\N	\N	2025-09-03 03:05:07.447+05:30	2025-09-03 03:05:07.447+05:30	\N
aw	abw	533	ARUBA	Aruba	\N	\N	2025-09-03 03:05:07.447+05:30	2025-09-03 03:05:07.447+05:30	\N
au	aus	036	AUSTRALIA	Australia	\N	\N	2025-09-03 03:05:07.447+05:30	2025-09-03 03:05:07.447+05:30	\N
at	aut	040	AUSTRIA	Austria	\N	\N	2025-09-03 03:05:07.447+05:30	2025-09-03 03:05:07.447+05:30	\N
az	aze	031	AZERBAIJAN	Azerbaijan	\N	\N	2025-09-03 03:05:07.447+05:30	2025-09-03 03:05:07.447+05:30	\N
bs	bhs	044	BAHAMAS	Bahamas	\N	\N	2025-09-03 03:05:07.447+05:30	2025-09-03 03:05:07.447+05:30	\N
bh	bhr	048	BAHRAIN	Bahrain	\N	\N	2025-09-03 03:05:07.447+05:30	2025-09-03 03:05:07.447+05:30	\N
bd	bgd	050	BANGLADESH	Bangladesh	\N	\N	2025-09-03 03:05:07.447+05:30	2025-09-03 03:05:07.447+05:30	\N
bb	brb	052	BARBADOS	Barbados	\N	\N	2025-09-03 03:05:07.447+05:30	2025-09-03 03:05:07.447+05:30	\N
by	blr	112	BELARUS	Belarus	\N	\N	2025-09-03 03:05:07.447+05:30	2025-09-03 03:05:07.447+05:30	\N
be	bel	056	BELGIUM	Belgium	\N	\N	2025-09-03 03:05:07.447+05:30	2025-09-03 03:05:07.447+05:30	\N
bz	blz	084	BELIZE	Belize	\N	\N	2025-09-03 03:05:07.447+05:30	2025-09-03 03:05:07.447+05:30	\N
bj	ben	204	BENIN	Benin	\N	\N	2025-09-03 03:05:07.447+05:30	2025-09-03 03:05:07.447+05:30	\N
bm	bmu	060	BERMUDA	Bermuda	\N	\N	2025-09-03 03:05:07.447+05:30	2025-09-03 03:05:07.447+05:30	\N
bt	btn	064	BHUTAN	Bhutan	\N	\N	2025-09-03 03:05:07.447+05:30	2025-09-03 03:05:07.447+05:30	\N
bo	bol	068	BOLIVIA	Bolivia	\N	\N	2025-09-03 03:05:07.447+05:30	2025-09-03 03:05:07.447+05:30	\N
bq	bes	535	BONAIRE, SINT EUSTATIUS AND SABA	Bonaire, Sint Eustatius and Saba	\N	\N	2025-09-03 03:05:07.447+05:30	2025-09-03 03:05:07.447+05:30	\N
ba	bih	070	BOSNIA AND HERZEGOVINA	Bosnia and Herzegovina	\N	\N	2025-09-03 03:05:07.447+05:30	2025-09-03 03:05:07.447+05:30	\N
bw	bwa	072	BOTSWANA	Botswana	\N	\N	2025-09-03 03:05:07.447+05:30	2025-09-03 03:05:07.447+05:30	\N
bv	bvd	074	BOUVET ISLAND	Bouvet Island	\N	\N	2025-09-03 03:05:07.447+05:30	2025-09-03 03:05:07.447+05:30	\N
br	bra	076	BRAZIL	Brazil	\N	\N	2025-09-03 03:05:07.447+05:30	2025-09-03 03:05:07.447+05:30	\N
io	iot	086	BRITISH INDIAN OCEAN TERRITORY	British Indian Ocean Territory	\N	\N	2025-09-03 03:05:07.447+05:30	2025-09-03 03:05:07.447+05:30	\N
bn	brn	096	BRUNEI DARUSSALAM	Brunei Darussalam	\N	\N	2025-09-03 03:05:07.447+05:30	2025-09-03 03:05:07.447+05:30	\N
bg	bgr	100	BULGARIA	Bulgaria	\N	\N	2025-09-03 03:05:07.447+05:30	2025-09-03 03:05:07.447+05:30	\N
bf	bfa	854	BURKINA FASO	Burkina Faso	\N	\N	2025-09-03 03:05:07.447+05:30	2025-09-03 03:05:07.447+05:30	\N
bi	bdi	108	BURUNDI	Burundi	\N	\N	2025-09-03 03:05:07.447+05:30	2025-09-03 03:05:07.447+05:30	\N
kh	khm	116	CAMBODIA	Cambodia	\N	\N	2025-09-03 03:05:07.447+05:30	2025-09-03 03:05:07.447+05:30	\N
cm	cmr	120	CAMEROON	Cameroon	\N	\N	2025-09-03 03:05:07.447+05:30	2025-09-03 03:05:07.447+05:30	\N
ca	can	124	CANADA	Canada	\N	\N	2025-09-03 03:05:07.447+05:30	2025-09-03 03:05:07.447+05:30	\N
cv	cpv	132	CAPE VERDE	Cape Verde	\N	\N	2025-09-03 03:05:07.447+05:30	2025-09-03 03:05:07.447+05:30	\N
ky	cym	136	CAYMAN ISLANDS	Cayman Islands	\N	\N	2025-09-03 03:05:07.447+05:30	2025-09-03 03:05:07.447+05:30	\N
cf	caf	140	CENTRAL AFRICAN REPUBLIC	Central African Republic	\N	\N	2025-09-03 03:05:07.447+05:30	2025-09-03 03:05:07.447+05:30	\N
td	tcd	148	CHAD	Chad	\N	\N	2025-09-03 03:05:07.447+05:30	2025-09-03 03:05:07.447+05:30	\N
cl	chl	152	CHILE	Chile	\N	\N	2025-09-03 03:05:07.447+05:30	2025-09-03 03:05:07.447+05:30	\N
cn	chn	156	CHINA	China	\N	\N	2025-09-03 03:05:07.447+05:30	2025-09-03 03:05:07.447+05:30	\N
cx	cxr	162	CHRISTMAS ISLAND	Christmas Island	\N	\N	2025-09-03 03:05:07.447+05:30	2025-09-03 03:05:07.447+05:30	\N
cc	cck	166	COCOS (KEELING) ISLANDS	Cocos (Keeling) Islands	\N	\N	2025-09-03 03:05:07.447+05:30	2025-09-03 03:05:07.447+05:30	\N
co	col	170	COLOMBIA	Colombia	\N	\N	2025-09-03 03:05:07.447+05:30	2025-09-03 03:05:07.447+05:30	\N
km	com	174	COMOROS	Comoros	\N	\N	2025-09-03 03:05:07.447+05:30	2025-09-03 03:05:07.447+05:30	\N
cg	cog	178	CONGO	Congo	\N	\N	2025-09-03 03:05:07.447+05:30	2025-09-03 03:05:07.447+05:30	\N
cd	cod	180	CONGO, THE DEMOCRATIC REPUBLIC OF THE	Congo, the Democratic Republic of the	\N	\N	2025-09-03 03:05:07.447+05:30	2025-09-03 03:05:07.447+05:30	\N
ck	cok	184	COOK ISLANDS	Cook Islands	\N	\N	2025-09-03 03:05:07.447+05:30	2025-09-03 03:05:07.447+05:30	\N
cr	cri	188	COSTA RICA	Costa Rica	\N	\N	2025-09-03 03:05:07.447+05:30	2025-09-03 03:05:07.447+05:30	\N
ci	civ	384	COTE D'IVOIRE	Cote D'Ivoire	\N	\N	2025-09-03 03:05:07.447+05:30	2025-09-03 03:05:07.447+05:30	\N
hr	hrv	191	CROATIA	Croatia	\N	\N	2025-09-03 03:05:07.447+05:30	2025-09-03 03:05:07.447+05:30	\N
cu	cub	192	CUBA	Cuba	\N	\N	2025-09-03 03:05:07.447+05:30	2025-09-03 03:05:07.447+05:30	\N
cw	cuw	531	CURAÇAO	Curaçao	\N	\N	2025-09-03 03:05:07.447+05:30	2025-09-03 03:05:07.447+05:30	\N
cy	cyp	196	CYPRUS	Cyprus	\N	\N	2025-09-03 03:05:07.447+05:30	2025-09-03 03:05:07.447+05:30	\N
cz	cze	203	CZECH REPUBLIC	Czech Republic	\N	\N	2025-09-03 03:05:07.447+05:30	2025-09-03 03:05:07.447+05:30	\N
dj	dji	262	DJIBOUTI	Djibouti	\N	\N	2025-09-03 03:05:07.447+05:30	2025-09-03 03:05:07.447+05:30	\N
dm	dma	212	DOMINICA	Dominica	\N	\N	2025-09-03 03:05:07.447+05:30	2025-09-03 03:05:07.447+05:30	\N
do	dom	214	DOMINICAN REPUBLIC	Dominican Republic	\N	\N	2025-09-03 03:05:07.447+05:30	2025-09-03 03:05:07.447+05:30	\N
ec	ecu	218	ECUADOR	Ecuador	\N	\N	2025-09-03 03:05:07.447+05:30	2025-09-03 03:05:07.447+05:30	\N
eg	egy	818	EGYPT	Egypt	\N	\N	2025-09-03 03:05:07.448+05:30	2025-09-03 03:05:07.448+05:30	\N
sv	slv	222	EL SALVADOR	El Salvador	\N	\N	2025-09-03 03:05:07.448+05:30	2025-09-03 03:05:07.448+05:30	\N
gq	gnq	226	EQUATORIAL GUINEA	Equatorial Guinea	\N	\N	2025-09-03 03:05:07.448+05:30	2025-09-03 03:05:07.448+05:30	\N
er	eri	232	ERITREA	Eritrea	\N	\N	2025-09-03 03:05:07.448+05:30	2025-09-03 03:05:07.448+05:30	\N
ee	est	233	ESTONIA	Estonia	\N	\N	2025-09-03 03:05:07.448+05:30	2025-09-03 03:05:07.448+05:30	\N
et	eth	231	ETHIOPIA	Ethiopia	\N	\N	2025-09-03 03:05:07.448+05:30	2025-09-03 03:05:07.448+05:30	\N
fk	flk	238	FALKLAND ISLANDS (MALVINAS)	Falkland Islands (Malvinas)	\N	\N	2025-09-03 03:05:07.448+05:30	2025-09-03 03:05:07.448+05:30	\N
fo	fro	234	FAROE ISLANDS	Faroe Islands	\N	\N	2025-09-03 03:05:07.448+05:30	2025-09-03 03:05:07.448+05:30	\N
fj	fji	242	FIJI	Fiji	\N	\N	2025-09-03 03:05:07.448+05:30	2025-09-03 03:05:07.448+05:30	\N
fi	fin	246	FINLAND	Finland	\N	\N	2025-09-03 03:05:07.448+05:30	2025-09-03 03:05:07.448+05:30	\N
gf	guf	254	FRENCH GUIANA	French Guiana	\N	\N	2025-09-03 03:05:07.448+05:30	2025-09-03 03:05:07.448+05:30	\N
pf	pyf	258	FRENCH POLYNESIA	French Polynesia	\N	\N	2025-09-03 03:05:07.448+05:30	2025-09-03 03:05:07.448+05:30	\N
tf	atf	260	FRENCH SOUTHERN TERRITORIES	French Southern Territories	\N	\N	2025-09-03 03:05:07.448+05:30	2025-09-03 03:05:07.448+05:30	\N
ga	gab	266	GABON	Gabon	\N	\N	2025-09-03 03:05:07.448+05:30	2025-09-03 03:05:07.448+05:30	\N
gm	gmb	270	GAMBIA	Gambia	\N	\N	2025-09-03 03:05:07.448+05:30	2025-09-03 03:05:07.448+05:30	\N
ge	geo	268	GEORGIA	Georgia	\N	\N	2025-09-03 03:05:07.448+05:30	2025-09-03 03:05:07.448+05:30	\N
gh	gha	288	GHANA	Ghana	\N	\N	2025-09-03 03:05:07.448+05:30	2025-09-03 03:05:07.448+05:30	\N
gi	gib	292	GIBRALTAR	Gibraltar	\N	\N	2025-09-03 03:05:07.448+05:30	2025-09-03 03:05:07.448+05:30	\N
gr	grc	300	GREECE	Greece	\N	\N	2025-09-03 03:05:07.448+05:30	2025-09-03 03:05:07.448+05:30	\N
gl	grl	304	GREENLAND	Greenland	\N	\N	2025-09-03 03:05:07.448+05:30	2025-09-03 03:05:07.448+05:30	\N
gd	grd	308	GRENADA	Grenada	\N	\N	2025-09-03 03:05:07.448+05:30	2025-09-03 03:05:07.448+05:30	\N
gp	glp	312	GUADELOUPE	Guadeloupe	\N	\N	2025-09-03 03:05:07.448+05:30	2025-09-03 03:05:07.448+05:30	\N
gu	gum	316	GUAM	Guam	\N	\N	2025-09-03 03:05:07.448+05:30	2025-09-03 03:05:07.448+05:30	\N
gt	gtm	320	GUATEMALA	Guatemala	\N	\N	2025-09-03 03:05:07.448+05:30	2025-09-03 03:05:07.448+05:30	\N
gg	ggy	831	GUERNSEY	Guernsey	\N	\N	2025-09-03 03:05:07.448+05:30	2025-09-03 03:05:07.448+05:30	\N
gn	gin	324	GUINEA	Guinea	\N	\N	2025-09-03 03:05:07.448+05:30	2025-09-03 03:05:07.448+05:30	\N
gw	gnb	624	GUINEA-BISSAU	Guinea-Bissau	\N	\N	2025-09-03 03:05:07.448+05:30	2025-09-03 03:05:07.448+05:30	\N
gy	guy	328	GUYANA	Guyana	\N	\N	2025-09-03 03:05:07.448+05:30	2025-09-03 03:05:07.448+05:30	\N
ht	hti	332	HAITI	Haiti	\N	\N	2025-09-03 03:05:07.448+05:30	2025-09-03 03:05:07.448+05:30	\N
hm	hmd	334	HEARD ISLAND AND MCDONALD ISLANDS	Heard Island And Mcdonald Islands	\N	\N	2025-09-03 03:05:07.448+05:30	2025-09-03 03:05:07.448+05:30	\N
va	vat	336	HOLY SEE (VATICAN CITY STATE)	Holy See (Vatican City State)	\N	\N	2025-09-03 03:05:07.448+05:30	2025-09-03 03:05:07.448+05:30	\N
hn	hnd	340	HONDURAS	Honduras	\N	\N	2025-09-03 03:05:07.448+05:30	2025-09-03 03:05:07.448+05:30	\N
hk	hkg	344	HONG KONG	Hong Kong	\N	\N	2025-09-03 03:05:07.448+05:30	2025-09-03 03:05:07.448+05:30	\N
hu	hun	348	HUNGARY	Hungary	\N	\N	2025-09-03 03:05:07.448+05:30	2025-09-03 03:05:07.448+05:30	\N
is	isl	352	ICELAND	Iceland	\N	\N	2025-09-03 03:05:07.448+05:30	2025-09-03 03:05:07.448+05:30	\N
in	ind	356	INDIA	India	\N	\N	2025-09-03 03:05:07.448+05:30	2025-09-03 03:05:07.448+05:30	\N
id	idn	360	INDONESIA	Indonesia	\N	\N	2025-09-03 03:05:07.448+05:30	2025-09-03 03:05:07.448+05:30	\N
ir	irn	364	IRAN, ISLAMIC REPUBLIC OF	Iran, Islamic Republic of	\N	\N	2025-09-03 03:05:07.448+05:30	2025-09-03 03:05:07.448+05:30	\N
iq	irq	368	IRAQ	Iraq	\N	\N	2025-09-03 03:05:07.448+05:30	2025-09-03 03:05:07.448+05:30	\N
ie	irl	372	IRELAND	Ireland	\N	\N	2025-09-03 03:05:07.448+05:30	2025-09-03 03:05:07.448+05:30	\N
im	imn	833	ISLE OF MAN	Isle Of Man	\N	\N	2025-09-03 03:05:07.448+05:30	2025-09-03 03:05:07.448+05:30	\N
il	isr	376	ISRAEL	Israel	\N	\N	2025-09-03 03:05:07.448+05:30	2025-09-03 03:05:07.448+05:30	\N
jm	jam	388	JAMAICA	Jamaica	\N	\N	2025-09-03 03:05:07.448+05:30	2025-09-03 03:05:07.448+05:30	\N
jp	jpn	392	JAPAN	Japan	\N	\N	2025-09-03 03:05:07.448+05:30	2025-09-03 03:05:07.448+05:30	\N
je	jey	832	JERSEY	Jersey	\N	\N	2025-09-03 03:05:07.448+05:30	2025-09-03 03:05:07.448+05:30	\N
jo	jor	400	JORDAN	Jordan	\N	\N	2025-09-03 03:05:07.448+05:30	2025-09-03 03:05:07.448+05:30	\N
kz	kaz	398	KAZAKHSTAN	Kazakhstan	\N	\N	2025-09-03 03:05:07.448+05:30	2025-09-03 03:05:07.448+05:30	\N
ke	ken	404	KENYA	Kenya	\N	\N	2025-09-03 03:05:07.448+05:30	2025-09-03 03:05:07.448+05:30	\N
ki	kir	296	KIRIBATI	Kiribati	\N	\N	2025-09-03 03:05:07.448+05:30	2025-09-03 03:05:07.448+05:30	\N
kp	prk	408	KOREA, DEMOCRATIC PEOPLE'S REPUBLIC OF	Korea, Democratic People's Republic of	\N	\N	2025-09-03 03:05:07.448+05:30	2025-09-03 03:05:07.448+05:30	\N
kr	kor	410	KOREA, REPUBLIC OF	Korea, Republic of	\N	\N	2025-09-03 03:05:07.448+05:30	2025-09-03 03:05:07.448+05:30	\N
xk	xkx	900	KOSOVO	Kosovo	\N	\N	2025-09-03 03:05:07.448+05:30	2025-09-03 03:05:07.448+05:30	\N
kw	kwt	414	KUWAIT	Kuwait	\N	\N	2025-09-03 03:05:07.448+05:30	2025-09-03 03:05:07.448+05:30	\N
kg	kgz	417	KYRGYZSTAN	Kyrgyzstan	\N	\N	2025-09-03 03:05:07.448+05:30	2025-09-03 03:05:07.448+05:30	\N
la	lao	418	LAO PEOPLE'S DEMOCRATIC REPUBLIC	Lao People's Democratic Republic	\N	\N	2025-09-03 03:05:07.448+05:30	2025-09-03 03:05:07.448+05:30	\N
lv	lva	428	LATVIA	Latvia	\N	\N	2025-09-03 03:05:07.448+05:30	2025-09-03 03:05:07.448+05:30	\N
lb	lbn	422	LEBANON	Lebanon	\N	\N	2025-09-03 03:05:07.448+05:30	2025-09-03 03:05:07.448+05:30	\N
ls	lso	426	LESOTHO	Lesotho	\N	\N	2025-09-03 03:05:07.448+05:30	2025-09-03 03:05:07.448+05:30	\N
lr	lbr	430	LIBERIA	Liberia	\N	\N	2025-09-03 03:05:07.448+05:30	2025-09-03 03:05:07.448+05:30	\N
ly	lby	434	LIBYA	Libya	\N	\N	2025-09-03 03:05:07.448+05:30	2025-09-03 03:05:07.448+05:30	\N
li	lie	438	LIECHTENSTEIN	Liechtenstein	\N	\N	2025-09-03 03:05:07.448+05:30	2025-09-03 03:05:07.448+05:30	\N
lt	ltu	440	LITHUANIA	Lithuania	\N	\N	2025-09-03 03:05:07.448+05:30	2025-09-03 03:05:07.448+05:30	\N
lu	lux	442	LUXEMBOURG	Luxembourg	\N	\N	2025-09-03 03:05:07.448+05:30	2025-09-03 03:05:07.448+05:30	\N
mo	mac	446	MACAO	Macao	\N	\N	2025-09-03 03:05:07.448+05:30	2025-09-03 03:05:07.448+05:30	\N
mg	mdg	450	MADAGASCAR	Madagascar	\N	\N	2025-09-03 03:05:07.448+05:30	2025-09-03 03:05:07.448+05:30	\N
mw	mwi	454	MALAWI	Malawi	\N	\N	2025-09-03 03:05:07.448+05:30	2025-09-03 03:05:07.448+05:30	\N
my	mys	458	MALAYSIA	Malaysia	\N	\N	2025-09-03 03:05:07.448+05:30	2025-09-03 03:05:07.448+05:30	\N
mv	mdv	462	MALDIVES	Maldives	\N	\N	2025-09-03 03:05:07.448+05:30	2025-09-03 03:05:07.448+05:30	\N
ml	mli	466	MALI	Mali	\N	\N	2025-09-03 03:05:07.448+05:30	2025-09-03 03:05:07.448+05:30	\N
mt	mlt	470	MALTA	Malta	\N	\N	2025-09-03 03:05:07.448+05:30	2025-09-03 03:05:07.448+05:30	\N
mh	mhl	584	MARSHALL ISLANDS	Marshall Islands	\N	\N	2025-09-03 03:05:07.448+05:30	2025-09-03 03:05:07.448+05:30	\N
mq	mtq	474	MARTINIQUE	Martinique	\N	\N	2025-09-03 03:05:07.448+05:30	2025-09-03 03:05:07.448+05:30	\N
mr	mrt	478	MAURITANIA	Mauritania	\N	\N	2025-09-03 03:05:07.448+05:30	2025-09-03 03:05:07.448+05:30	\N
mu	mus	480	MAURITIUS	Mauritius	\N	\N	2025-09-03 03:05:07.448+05:30	2025-09-03 03:05:07.448+05:30	\N
yt	myt	175	MAYOTTE	Mayotte	\N	\N	2025-09-03 03:05:07.448+05:30	2025-09-03 03:05:07.448+05:30	\N
mx	mex	484	MEXICO	Mexico	\N	\N	2025-09-03 03:05:07.448+05:30	2025-09-03 03:05:07.448+05:30	\N
fm	fsm	583	MICRONESIA, FEDERATED STATES OF	Micronesia, Federated States of	\N	\N	2025-09-03 03:05:07.448+05:30	2025-09-03 03:05:07.448+05:30	\N
md	mda	498	MOLDOVA, REPUBLIC OF	Moldova, Republic of	\N	\N	2025-09-03 03:05:07.448+05:30	2025-09-03 03:05:07.448+05:30	\N
mc	mco	492	MONACO	Monaco	\N	\N	2025-09-03 03:05:07.448+05:30	2025-09-03 03:05:07.448+05:30	\N
mn	mng	496	MONGOLIA	Mongolia	\N	\N	2025-09-03 03:05:07.448+05:30	2025-09-03 03:05:07.448+05:30	\N
me	mne	499	MONTENEGRO	Montenegro	\N	\N	2025-09-03 03:05:07.448+05:30	2025-09-03 03:05:07.448+05:30	\N
ms	msr	500	MONTSERRAT	Montserrat	\N	\N	2025-09-03 03:05:07.448+05:30	2025-09-03 03:05:07.448+05:30	\N
ma	mar	504	MOROCCO	Morocco	\N	\N	2025-09-03 03:05:07.448+05:30	2025-09-03 03:05:07.448+05:30	\N
mz	moz	508	MOZAMBIQUE	Mozambique	\N	\N	2025-09-03 03:05:07.448+05:30	2025-09-03 03:05:07.448+05:30	\N
mm	mmr	104	MYANMAR	Myanmar	\N	\N	2025-09-03 03:05:07.448+05:30	2025-09-03 03:05:07.448+05:30	\N
na	nam	516	NAMIBIA	Namibia	\N	\N	2025-09-03 03:05:07.448+05:30	2025-09-03 03:05:07.448+05:30	\N
nr	nru	520	NAURU	Nauru	\N	\N	2025-09-03 03:05:07.448+05:30	2025-09-03 03:05:07.448+05:30	\N
np	npl	524	NEPAL	Nepal	\N	\N	2025-09-03 03:05:07.448+05:30	2025-09-03 03:05:07.448+05:30	\N
nl	nld	528	NETHERLANDS	Netherlands	\N	\N	2025-09-03 03:05:07.448+05:30	2025-09-03 03:05:07.448+05:30	\N
nc	ncl	540	NEW CALEDONIA	New Caledonia	\N	\N	2025-09-03 03:05:07.448+05:30	2025-09-03 03:05:07.448+05:30	\N
nz	nzl	554	NEW ZEALAND	New Zealand	\N	\N	2025-09-03 03:05:07.448+05:30	2025-09-03 03:05:07.448+05:30	\N
ni	nic	558	NICARAGUA	Nicaragua	\N	\N	2025-09-03 03:05:07.448+05:30	2025-09-03 03:05:07.448+05:30	\N
ne	ner	562	NIGER	Niger	\N	\N	2025-09-03 03:05:07.448+05:30	2025-09-03 03:05:07.448+05:30	\N
ng	nga	566	NIGERIA	Nigeria	\N	\N	2025-09-03 03:05:07.448+05:30	2025-09-03 03:05:07.448+05:30	\N
nu	niu	570	NIUE	Niue	\N	\N	2025-09-03 03:05:07.448+05:30	2025-09-03 03:05:07.448+05:30	\N
nf	nfk	574	NORFOLK ISLAND	Norfolk Island	\N	\N	2025-09-03 03:05:07.448+05:30	2025-09-03 03:05:07.448+05:30	\N
mk	mkd	807	NORTH MACEDONIA	North Macedonia	\N	\N	2025-09-03 03:05:07.448+05:30	2025-09-03 03:05:07.448+05:30	\N
mp	mnp	580	NORTHERN MARIANA ISLANDS	Northern Mariana Islands	\N	\N	2025-09-03 03:05:07.448+05:30	2025-09-03 03:05:07.448+05:30	\N
no	nor	578	NORWAY	Norway	\N	\N	2025-09-03 03:05:07.448+05:30	2025-09-03 03:05:07.448+05:30	\N
om	omn	512	OMAN	Oman	\N	\N	2025-09-03 03:05:07.448+05:30	2025-09-03 03:05:07.448+05:30	\N
pk	pak	586	PAKISTAN	Pakistan	\N	\N	2025-09-03 03:05:07.448+05:30	2025-09-03 03:05:07.448+05:30	\N
pw	plw	585	PALAU	Palau	\N	\N	2025-09-03 03:05:07.448+05:30	2025-09-03 03:05:07.448+05:30	\N
ps	pse	275	PALESTINIAN TERRITORY, OCCUPIED	Palestinian Territory, Occupied	\N	\N	2025-09-03 03:05:07.448+05:30	2025-09-03 03:05:07.448+05:30	\N
pa	pan	591	PANAMA	Panama	\N	\N	2025-09-03 03:05:07.448+05:30	2025-09-03 03:05:07.448+05:30	\N
pg	png	598	PAPUA NEW GUINEA	Papua New Guinea	\N	\N	2025-09-03 03:05:07.448+05:30	2025-09-03 03:05:07.448+05:30	\N
py	pry	600	PARAGUAY	Paraguay	\N	\N	2025-09-03 03:05:07.448+05:30	2025-09-03 03:05:07.448+05:30	\N
pe	per	604	PERU	Peru	\N	\N	2025-09-03 03:05:07.448+05:30	2025-09-03 03:05:07.448+05:30	\N
pn	pcn	612	PITCAIRN	Pitcairn	\N	\N	2025-09-03 03:05:07.448+05:30	2025-09-03 03:05:07.448+05:30	\N
pl	pol	616	POLAND	Poland	\N	\N	2025-09-03 03:05:07.448+05:30	2025-09-03 03:05:07.448+05:30	\N
pt	prt	620	PORTUGAL	Portugal	\N	\N	2025-09-03 03:05:07.448+05:30	2025-09-03 03:05:07.448+05:30	\N
pr	pri	630	PUERTO RICO	Puerto Rico	\N	\N	2025-09-03 03:05:07.448+05:30	2025-09-03 03:05:07.448+05:30	\N
qa	qat	634	QATAR	Qatar	\N	\N	2025-09-03 03:05:07.448+05:30	2025-09-03 03:05:07.448+05:30	\N
re	reu	638	REUNION	Reunion	\N	\N	2025-09-03 03:05:07.448+05:30	2025-09-03 03:05:07.448+05:30	\N
ro	rom	642	ROMANIA	Romania	\N	\N	2025-09-03 03:05:07.448+05:30	2025-09-03 03:05:07.448+05:30	\N
ph	phl	608	PHILIPPINES	Philippines	reg_01K46BWK51BRTM8J2035TXGP7Z	\N	2025-09-03 03:05:07.448+05:30	2025-09-03 04:53:42.115+05:30	\N
ru	rus	643	RUSSIAN FEDERATION	Russian Federation	\N	\N	2025-09-03 03:05:07.448+05:30	2025-09-03 03:05:07.448+05:30	\N
rw	rwa	646	RWANDA	Rwanda	\N	\N	2025-09-03 03:05:07.448+05:30	2025-09-03 03:05:07.448+05:30	\N
bl	blm	652	SAINT BARTHÉLEMY	Saint Barthélemy	\N	\N	2025-09-03 03:05:07.448+05:30	2025-09-03 03:05:07.448+05:30	\N
sh	shn	654	SAINT HELENA	Saint Helena	\N	\N	2025-09-03 03:05:07.448+05:30	2025-09-03 03:05:07.448+05:30	\N
kn	kna	659	SAINT KITTS AND NEVIS	Saint Kitts and Nevis	\N	\N	2025-09-03 03:05:07.448+05:30	2025-09-03 03:05:07.448+05:30	\N
lc	lca	662	SAINT LUCIA	Saint Lucia	\N	\N	2025-09-03 03:05:07.448+05:30	2025-09-03 03:05:07.448+05:30	\N
mf	maf	663	SAINT MARTIN (FRENCH PART)	Saint Martin (French part)	\N	\N	2025-09-03 03:05:07.448+05:30	2025-09-03 03:05:07.448+05:30	\N
pm	spm	666	SAINT PIERRE AND MIQUELON	Saint Pierre and Miquelon	\N	\N	2025-09-03 03:05:07.448+05:30	2025-09-03 03:05:07.448+05:30	\N
vc	vct	670	SAINT VINCENT AND THE GRENADINES	Saint Vincent and the Grenadines	\N	\N	2025-09-03 03:05:07.448+05:30	2025-09-03 03:05:07.448+05:30	\N
ws	wsm	882	SAMOA	Samoa	\N	\N	2025-09-03 03:05:07.448+05:30	2025-09-03 03:05:07.448+05:30	\N
sm	smr	674	SAN MARINO	San Marino	\N	\N	2025-09-03 03:05:07.448+05:30	2025-09-03 03:05:07.448+05:30	\N
st	stp	678	SAO TOME AND PRINCIPE	Sao Tome and Principe	\N	\N	2025-09-03 03:05:07.448+05:30	2025-09-03 03:05:07.448+05:30	\N
sa	sau	682	SAUDI ARABIA	Saudi Arabia	\N	\N	2025-09-03 03:05:07.448+05:30	2025-09-03 03:05:07.448+05:30	\N
sn	sen	686	SENEGAL	Senegal	\N	\N	2025-09-03 03:05:07.448+05:30	2025-09-03 03:05:07.448+05:30	\N
rs	srb	688	SERBIA	Serbia	\N	\N	2025-09-03 03:05:07.448+05:30	2025-09-03 03:05:07.448+05:30	\N
sc	syc	690	SEYCHELLES	Seychelles	\N	\N	2025-09-03 03:05:07.448+05:30	2025-09-03 03:05:07.448+05:30	\N
sl	sle	694	SIERRA LEONE	Sierra Leone	\N	\N	2025-09-03 03:05:07.448+05:30	2025-09-03 03:05:07.448+05:30	\N
sg	sgp	702	SINGAPORE	Singapore	\N	\N	2025-09-03 03:05:07.448+05:30	2025-09-03 03:05:07.448+05:30	\N
sx	sxm	534	SINT MAARTEN	Sint Maarten	\N	\N	2025-09-03 03:05:07.448+05:30	2025-09-03 03:05:07.448+05:30	\N
sk	svk	703	SLOVAKIA	Slovakia	\N	\N	2025-09-03 03:05:07.448+05:30	2025-09-03 03:05:07.448+05:30	\N
si	svn	705	SLOVENIA	Slovenia	\N	\N	2025-09-03 03:05:07.448+05:30	2025-09-03 03:05:07.448+05:30	\N
sb	slb	090	SOLOMON ISLANDS	Solomon Islands	\N	\N	2025-09-03 03:05:07.448+05:30	2025-09-03 03:05:07.448+05:30	\N
so	som	706	SOMALIA	Somalia	\N	\N	2025-09-03 03:05:07.448+05:30	2025-09-03 03:05:07.448+05:30	\N
za	zaf	710	SOUTH AFRICA	South Africa	\N	\N	2025-09-03 03:05:07.448+05:30	2025-09-03 03:05:07.448+05:30	\N
gs	sgs	239	SOUTH GEORGIA AND THE SOUTH SANDWICH ISLANDS	South Georgia and the South Sandwich Islands	\N	\N	2025-09-03 03:05:07.448+05:30	2025-09-03 03:05:07.448+05:30	\N
ss	ssd	728	SOUTH SUDAN	South Sudan	\N	\N	2025-09-03 03:05:07.448+05:30	2025-09-03 03:05:07.448+05:30	\N
lk	lka	144	SRI LANKA	Sri Lanka	\N	\N	2025-09-03 03:05:07.448+05:30	2025-09-03 03:05:07.448+05:30	\N
sd	sdn	729	SUDAN	Sudan	\N	\N	2025-09-03 03:05:07.448+05:30	2025-09-03 03:05:07.448+05:30	\N
sr	sur	740	SURINAME	Suriname	\N	\N	2025-09-03 03:05:07.448+05:30	2025-09-03 03:05:07.448+05:30	\N
sj	sjm	744	SVALBARD AND JAN MAYEN	Svalbard and Jan Mayen	\N	\N	2025-09-03 03:05:07.448+05:30	2025-09-03 03:05:07.448+05:30	\N
sz	swz	748	SWAZILAND	Swaziland	\N	\N	2025-09-03 03:05:07.448+05:30	2025-09-03 03:05:07.448+05:30	\N
ch	che	756	SWITZERLAND	Switzerland	\N	\N	2025-09-03 03:05:07.448+05:30	2025-09-03 03:05:07.448+05:30	\N
sy	syr	760	SYRIAN ARAB REPUBLIC	Syrian Arab Republic	\N	\N	2025-09-03 03:05:07.448+05:30	2025-09-03 03:05:07.448+05:30	\N
tw	twn	158	TAIWAN, PROVINCE OF CHINA	Taiwan, Province of China	\N	\N	2025-09-03 03:05:07.448+05:30	2025-09-03 03:05:07.448+05:30	\N
tj	tjk	762	TAJIKISTAN	Tajikistan	\N	\N	2025-09-03 03:05:07.448+05:30	2025-09-03 03:05:07.448+05:30	\N
tz	tza	834	TANZANIA, UNITED REPUBLIC OF	Tanzania, United Republic of	\N	\N	2025-09-03 03:05:07.448+05:30	2025-09-03 03:05:07.448+05:30	\N
th	tha	764	THAILAND	Thailand	\N	\N	2025-09-03 03:05:07.448+05:30	2025-09-03 03:05:07.448+05:30	\N
tl	tls	626	TIMOR LESTE	Timor Leste	\N	\N	2025-09-03 03:05:07.448+05:30	2025-09-03 03:05:07.448+05:30	\N
tg	tgo	768	TOGO	Togo	\N	\N	2025-09-03 03:05:07.448+05:30	2025-09-03 03:05:07.448+05:30	\N
tk	tkl	772	TOKELAU	Tokelau	\N	\N	2025-09-03 03:05:07.448+05:30	2025-09-03 03:05:07.448+05:30	\N
to	ton	776	TONGA	Tonga	\N	\N	2025-09-03 03:05:07.448+05:30	2025-09-03 03:05:07.448+05:30	\N
tt	tto	780	TRINIDAD AND TOBAGO	Trinidad and Tobago	\N	\N	2025-09-03 03:05:07.448+05:30	2025-09-03 03:05:07.448+05:30	\N
tn	tun	788	TUNISIA	Tunisia	\N	\N	2025-09-03 03:05:07.448+05:30	2025-09-03 03:05:07.448+05:30	\N
tr	tur	792	TURKEY	Turkey	\N	\N	2025-09-03 03:05:07.448+05:30	2025-09-03 03:05:07.448+05:30	\N
tm	tkm	795	TURKMENISTAN	Turkmenistan	\N	\N	2025-09-03 03:05:07.448+05:30	2025-09-03 03:05:07.448+05:30	\N
tc	tca	796	TURKS AND CAICOS ISLANDS	Turks and Caicos Islands	\N	\N	2025-09-03 03:05:07.448+05:30	2025-09-03 03:05:07.448+05:30	\N
tv	tuv	798	TUVALU	Tuvalu	\N	\N	2025-09-03 03:05:07.448+05:30	2025-09-03 03:05:07.448+05:30	\N
ug	uga	800	UGANDA	Uganda	\N	\N	2025-09-03 03:05:07.448+05:30	2025-09-03 03:05:07.448+05:30	\N
ua	ukr	804	UKRAINE	Ukraine	\N	\N	2025-09-03 03:05:07.448+05:30	2025-09-03 03:05:07.448+05:30	\N
ae	are	784	UNITED ARAB EMIRATES	United Arab Emirates	\N	\N	2025-09-03 03:05:07.448+05:30	2025-09-03 03:05:07.448+05:30	\N
us	usa	840	UNITED STATES	United States	\N	\N	2025-09-03 03:05:07.448+05:30	2025-09-03 03:05:07.448+05:30	\N
um	umi	581	UNITED STATES MINOR OUTLYING ISLANDS	United States Minor Outlying Islands	\N	\N	2025-09-03 03:05:07.448+05:30	2025-09-03 03:05:07.448+05:30	\N
uy	ury	858	URUGUAY	Uruguay	\N	\N	2025-09-03 03:05:07.448+05:30	2025-09-03 03:05:07.448+05:30	\N
uz	uzb	860	UZBEKISTAN	Uzbekistan	\N	\N	2025-09-03 03:05:07.448+05:30	2025-09-03 03:05:07.448+05:30	\N
vu	vut	548	VANUATU	Vanuatu	\N	\N	2025-09-03 03:05:07.448+05:30	2025-09-03 03:05:07.448+05:30	\N
ve	ven	862	VENEZUELA	Venezuela	\N	\N	2025-09-03 03:05:07.448+05:30	2025-09-03 03:05:07.448+05:30	\N
vn	vnm	704	VIET NAM	Viet Nam	\N	\N	2025-09-03 03:05:07.448+05:30	2025-09-03 03:05:07.448+05:30	\N
vg	vgb	092	VIRGIN ISLANDS, BRITISH	Virgin Islands, British	\N	\N	2025-09-03 03:05:07.448+05:30	2025-09-03 03:05:07.448+05:30	\N
vi	vir	850	VIRGIN ISLANDS, U.S.	Virgin Islands, U.S.	\N	\N	2025-09-03 03:05:07.448+05:30	2025-09-03 03:05:07.448+05:30	\N
wf	wlf	876	WALLIS AND FUTUNA	Wallis and Futuna	\N	\N	2025-09-03 03:05:07.448+05:30	2025-09-03 03:05:07.448+05:30	\N
eh	esh	732	WESTERN SAHARA	Western Sahara	\N	\N	2025-09-03 03:05:07.448+05:30	2025-09-03 03:05:07.448+05:30	\N
ye	yem	887	YEMEN	Yemen	\N	\N	2025-09-03 03:05:07.448+05:30	2025-09-03 03:05:07.448+05:30	\N
zm	zmb	894	ZAMBIA	Zambia	\N	\N	2025-09-03 03:05:07.448+05:30	2025-09-03 03:05:07.448+05:30	\N
zw	zwe	716	ZIMBABWE	Zimbabwe	\N	\N	2025-09-03 03:05:07.448+05:30	2025-09-03 03:05:07.448+05:30	\N
ax	ala	248	ÅLAND ISLANDS	Åland Islands	\N	\N	2025-09-03 03:05:07.448+05:30	2025-09-03 03:05:07.448+05:30	\N
dk	dnk	208	DENMARK	Denmark	reg_01K465NWZBB589QBS334WRK4PF	\N	2025-09-03 03:05:07.447+05:30	2025-09-03 03:05:11.342+05:30	\N
fr	fra	250	FRANCE	France	reg_01K465NWZBB589QBS334WRK4PF	\N	2025-09-03 03:05:07.448+05:30	2025-09-03 03:05:11.342+05:30	\N
de	deu	276	GERMANY	Germany	reg_01K465NWZBB589QBS334WRK4PF	\N	2025-09-03 03:05:07.448+05:30	2025-09-03 03:05:11.342+05:30	\N
it	ita	380	ITALY	Italy	reg_01K465NWZBB589QBS334WRK4PF	\N	2025-09-03 03:05:07.448+05:30	2025-09-03 03:05:11.342+05:30	\N
es	esp	724	SPAIN	Spain	reg_01K465NWZBB589QBS334WRK4PF	\N	2025-09-03 03:05:07.448+05:30	2025-09-03 03:05:11.342+05:30	\N
se	swe	752	SWEDEN	Sweden	reg_01K465NWZBB589QBS334WRK4PF	\N	2025-09-03 03:05:07.448+05:30	2025-09-03 03:05:11.342+05:30	\N
gb	gbr	826	UNITED KINGDOM	United Kingdom	reg_01K465NWZBB589QBS334WRK4PF	\N	2025-09-03 03:05:07.448+05:30	2025-09-03 03:05:11.342+05:30	\N
\.


--
-- Data for Name: region_payment_provider; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.region_payment_provider (region_id, payment_provider_id, id, created_at, updated_at, deleted_at) FROM stdin;
reg_01K465NWZBB589QBS334WRK4PF	pp_system_default	regpp_01K465NWZP6RZ3Z4V014P9K7XY	2025-09-03 03:05:11.35067+05:30	2025-09-03 04:53:42.111+05:30	2025-09-03 04:53:42.11+05:30
reg_01K46BWK51BRTM8J2035TXGP7Z	pp_system_default	regpp_01K46BWK5AHP4F4X4T818469NY	2025-09-03 04:53:42.122368+05:30	2025-09-03 04:53:42.122368+05:30	\N
\.


--
-- Data for Name: reservation_item; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.reservation_item (id, created_at, updated_at, deleted_at, line_item_id, location_id, quantity, external_id, description, created_by, metadata, inventory_item_id, allow_backorder, raw_quantity) FROM stdin;
resitem_01K46A1CR6YBS3PKSK2MT4SZA9	2025-09-03 04:21:22.247+05:30	2025-09-03 04:58:46.231+05:30	2025-09-03 04:58:46.218+05:30	ordli_01K46A1CNQC8HHYQH4KJ54AGP4	sloc_01K465NX02PRA37GR065XPNVC1	1	\N	\N	\N	\N	iitem_01K465NX3KN80Z3BCCYJFH27BP	f	{"value": "1", "precision": 20}
\.


--
-- Data for Name: return; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.return (id, order_id, claim_id, exchange_id, order_version, display_id, status, no_notification, refund_amount, raw_refund_amount, metadata, created_at, updated_at, deleted_at, received_at, canceled_at, location_id, requested_at, created_by) FROM stdin;
\.


--
-- Data for Name: return_fulfillment; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.return_fulfillment (return_id, fulfillment_id, id, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: return_item; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.return_item (id, return_id, reason_id, item_id, quantity, raw_quantity, received_quantity, raw_received_quantity, note, metadata, created_at, updated_at, deleted_at, damaged_quantity, raw_damaged_quantity) FROM stdin;
\.


--
-- Data for Name: return_reason; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.return_reason (id, value, label, description, metadata, parent_return_reason_id, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: sales_channel; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sales_channel (id, name, description, is_disabled, metadata, created_at, updated_at, deleted_at) FROM stdin;
sc_01K465NVAAFMSJ0RGP5VCKEPVH	Default Sales Channel	Created by Medusa	f	\N	2025-09-03 03:05:09.642+05:30	2025-09-03 03:05:09.642+05:30	\N
\.


--
-- Data for Name: sales_channel_stock_location; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sales_channel_stock_location (sales_channel_id, stock_location_id, id, created_at, updated_at, deleted_at) FROM stdin;
sc_01K465NVAAFMSJ0RGP5VCKEPVH	sloc_01K465NX02PRA37GR065XPNVC1	scloc_01K465NX1HE1H0HPB0MERN5MYN	2025-09-03 03:05:11.409799+05:30	2025-09-03 03:05:11.409799+05:30	\N
\.


--
-- Data for Name: script_migrations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.script_migrations (id, script_name, created_at, finished_at) FROM stdin;
1	migrate-product-shipping-profile.js	2025-09-03 03:05:07.912949+05:30	2025-09-03 03:05:07.92851+05:30
2	migrate-tax-region-provider.js	2025-09-03 03:05:07.930752+05:30	2025-09-03 03:05:07.936385+05:30
\.


--
-- Data for Name: service_zone; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.service_zone (id, name, metadata, fulfillment_set_id, created_at, updated_at, deleted_at) FROM stdin;
serzo_01K465NX0B8X83QPDS4ZNJX86S	Europe	\N	fuset_01K465NX0BS3XBXW4G9VJ79T0Z	2025-09-03 03:05:11.371+05:30	2025-09-03 03:05:11.371+05:30	\N
\.


--
-- Data for Name: shipping_option; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.shipping_option (id, name, price_type, service_zone_id, shipping_profile_id, provider_id, data, metadata, shipping_option_type_id, created_at, updated_at, deleted_at) FROM stdin;
so_01K465NX0W8FHES8P37CAFHZS3	Standard Shipping	flat	serzo_01K465NX0B8X83QPDS4ZNJX86S	sp_01K465NSMNCMB3KTQC20148JAW	manual_manual	\N	\N	sotype_01K465NX0WGE47H7NC6TPMQ1VT	2025-09-03 03:05:11.389+05:30	2025-09-03 03:05:11.389+05:30	\N
so_01K465NX0XKTCXM3W7TXR75VPD	Express Shipping	flat	serzo_01K465NX0B8X83QPDS4ZNJX86S	sp_01K465NSMNCMB3KTQC20148JAW	manual_manual	\N	\N	sotype_01K465NX0XGS4NMCCBNZ8SBCMC	2025-09-03 03:05:11.389+05:30	2025-09-03 03:05:11.389+05:30	\N
\.


--
-- Data for Name: shipping_option_price_set; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.shipping_option_price_set (shipping_option_id, price_set_id, id, created_at, updated_at, deleted_at) FROM stdin;
so_01K465NX0W8FHES8P37CAFHZS3	pset_01K465NX13CASJ8S3MJ3RY8NN0	sops_01K465NX1FN5NM7QQ64AW028JG	2025-09-03 03:05:11.407265+05:30	2025-09-03 03:05:11.407265+05:30	\N
so_01K465NX0XKTCXM3W7TXR75VPD	pset_01K465NX1352A7Y6X0KEY321EJ	sops_01K465NX1FTVM51JB8MPHWGADX	2025-09-03 03:05:11.407265+05:30	2025-09-03 03:05:11.407265+05:30	\N
\.


--
-- Data for Name: shipping_option_rule; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.shipping_option_rule (id, attribute, operator, value, shipping_option_id, created_at, updated_at, deleted_at) FROM stdin;
sorul_01K465NX0WQBVPHFBM8QDE8K30	enabled_in_store	eq	"true"	so_01K465NX0W8FHES8P37CAFHZS3	2025-09-03 03:05:11.389+05:30	2025-09-03 03:05:11.389+05:30	\N
sorul_01K465NX0W4SSYYGKDNNX6R1TX	is_return	eq	"false"	so_01K465NX0W8FHES8P37CAFHZS3	2025-09-03 03:05:11.389+05:30	2025-09-03 03:05:11.389+05:30	\N
sorul_01K465NX0XGN9FV4QVBNY4N3RS	enabled_in_store	eq	"true"	so_01K465NX0XKTCXM3W7TXR75VPD	2025-09-03 03:05:11.389+05:30	2025-09-03 03:05:11.389+05:30	\N
sorul_01K465NX0XD4T5ZMD8FDB4C69Y	is_return	eq	"false"	so_01K465NX0XKTCXM3W7TXR75VPD	2025-09-03 03:05:11.389+05:30	2025-09-03 03:05:11.389+05:30	\N
\.


--
-- Data for Name: shipping_option_type; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.shipping_option_type (id, label, description, code, created_at, updated_at, deleted_at) FROM stdin;
sotype_01K465NX0WGE47H7NC6TPMQ1VT	Standard	Ship in 2-3 days.	standard	2025-09-03 03:05:11.389+05:30	2025-09-03 03:05:11.389+05:30	\N
sotype_01K465NX0XGS4NMCCBNZ8SBCMC	Express	Ship in 24 hours.	express	2025-09-03 03:05:11.389+05:30	2025-09-03 03:05:11.389+05:30	\N
\.


--
-- Data for Name: shipping_profile; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.shipping_profile (id, name, type, metadata, created_at, updated_at, deleted_at) FROM stdin;
sp_01K465NSMNCMB3KTQC20148JAW	Default Shipping Profile	default	\N	2025-09-03 03:05:07.926+05:30	2025-09-03 03:05:07.926+05:30	\N
\.


--
-- Data for Name: stock_location; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.stock_location (id, created_at, updated_at, deleted_at, name, address_id, metadata) FROM stdin;
sloc_01K465NX02PRA37GR065XPNVC1	2025-09-03 03:05:11.363+05:30	2025-09-03 03:05:11.363+05:30	\N	European Warehouse	laddr_01K465NX02JG26E8Z5N4C83M68	\N
\.


--
-- Data for Name: stock_location_address; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.stock_location_address (id, created_at, updated_at, deleted_at, address_1, address_2, company, city, country_code, phone, province, postal_code, metadata) FROM stdin;
laddr_01K465NX02JG26E8Z5N4C83M68	2025-09-03 03:05:11.362+05:30	2025-09-03 03:05:11.362+05:30	\N		\N	\N	Copenhagen	DK	\N	\N	\N	\N
\.


--
-- Data for Name: store; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.store (id, name, default_sales_channel_id, default_region_id, default_location_id, metadata, created_at, updated_at, deleted_at) FROM stdin;
store_01K465NVAFZKTAQXD503TJBMJV	Medusa Store	sc_01K465NVAAFMSJ0RGP5VCKEPVH	\N	\N	\N	2025-09-03 03:05:09.647307+05:30	2025-09-03 03:05:09.647307+05:30	\N
\.


--
-- Data for Name: store_currency; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.store_currency (id, currency_code, is_default, store_id, created_at, updated_at, deleted_at) FROM stdin;
stocur_01K46BWK40HW107G1EDSNJWT9J	php	t	store_01K465NVAFZKTAQXD503TJBMJV	2025-09-03 04:53:42.073633+05:30	2025-09-03 04:53:42.073633+05:30	\N
stocur_01K46BWK40X61ZP3EBWBY3EW6H	usd	f	store_01K465NVAFZKTAQXD503TJBMJV	2025-09-03 04:53:42.073633+05:30	2025-09-03 04:53:42.073633+05:30	\N
\.


--
-- Data for Name: tax_provider; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tax_provider (id, is_enabled, created_at, updated_at, deleted_at) FROM stdin;
tp_system	t	2025-09-03 03:05:07.455+05:30	2025-09-03 03:05:07.455+05:30	\N
\.


--
-- Data for Name: tax_rate; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tax_rate (id, rate, code, name, is_default, is_combinable, tax_region_id, metadata, created_at, updated_at, created_by, deleted_at) FROM stdin;
\.


--
-- Data for Name: tax_rate_rule; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tax_rate_rule (id, tax_rate_id, reference_id, reference, metadata, created_at, updated_at, created_by, deleted_at) FROM stdin;
\.


--
-- Data for Name: tax_region; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tax_region (id, provider_id, country_code, province_code, parent_id, metadata, created_at, updated_at, created_by, deleted_at) FROM stdin;
txreg_01K465NWZTKW2YFWQEHRCWYCPR	tp_system	gb	\N	\N	\N	2025-09-03 03:05:11.355+05:30	2025-09-03 03:05:11.355+05:30	\N	\N
txreg_01K465NWZTT31MH4MS6P33K8Z4	tp_system	de	\N	\N	\N	2025-09-03 03:05:11.355+05:30	2025-09-03 03:05:11.355+05:30	\N	\N
txreg_01K465NWZTVHMVWJ54NK4KKH8Q	tp_system	dk	\N	\N	\N	2025-09-03 03:05:11.355+05:30	2025-09-03 03:05:11.355+05:30	\N	\N
txreg_01K465NWZVYYY6BE17WN7H5W22	tp_system	se	\N	\N	\N	2025-09-03 03:05:11.355+05:30	2025-09-03 03:05:11.355+05:30	\N	\N
txreg_01K465NWZVT5QC8M0JHZV6SY8P	tp_system	fr	\N	\N	\N	2025-09-03 03:05:11.355+05:30	2025-09-03 03:05:11.355+05:30	\N	\N
txreg_01K465NWZV49KVDCQWAP9QRYYP	tp_system	es	\N	\N	\N	2025-09-03 03:05:11.355+05:30	2025-09-03 03:05:11.355+05:30	\N	\N
txreg_01K465NWZVETRQMCSDDY5V5C96	tp_system	it	\N	\N	\N	2025-09-03 03:05:11.355+05:30	2025-09-03 03:05:11.355+05:30	\N	\N
txreg_01K46BWK5E5HY0Y50DC9F4XBYH	tp_system	ph	\N	\N	\N	2025-09-03 04:53:42.126+05:30	2025-09-03 04:53:42.126+05:30	\N	\N
\.


--
-- Data for Name: user; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."user" (id, first_name, last_name, email, avatar_url, metadata, created_at, updated_at, deleted_at) FROM stdin;
user_01K4699ZKG51FE37TNHEG4X7HR	krat0s	\N	mukulyadav49@gmail.com	\N	\N	2025-09-03 04:08:35.12+05:30	2025-09-03 04:08:35.12+05:30	\N
\.


--
-- Data for Name: user_preference; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_preference (id, user_id, key, value, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: view_configuration; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.view_configuration (id, entity, name, user_id, is_system_default, configuration, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: workflow_execution; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.workflow_execution (id, workflow_id, transaction_id, execution, context, state, created_at, updated_at, deleted_at, retention_time, run_id) FROM stdin;
wf_exec_01K466AXJV3MFHV64E8QCSGPNE	update-cart-promotions	update-cart-promotions-as-step-auto-01K466AXGTYBSJHXWJ856CK0JD	{"runId": "01K466AXGXNZQMRNTR9DRXWM95", "state": "done", "steps": {"_root": {"id": "_root", "next": ["_root.use-remote-query"]}, "_root.use-remote-query": {"id": "_root.use-remote-query", "next": ["_root.use-remote-query.validate"], "uuid": "01K4663BPWX35XJVDTWBF7WFQY", "depth": 1, "invoke": {"state": "done", "status": "ok"}, "attempts": 1, "failures": 0, "startedAt": 1756849600103, "compensate": {"state": "dormant", "status": "idle"}, "definition": {"uuid": "01K4663BPWX35XJVDTWBF7WFQY", "action": "use-remote-query", "noCompensation": true}, "stepFailed": false, "lastAttempt": 1756849600103, "saveResponse": true}, "_root.use-remote-query.validate": {"id": "_root.use-remote-query.validate", "next": ["_root.use-remote-query.validate.get-promotion-codes-to-apply"], "uuid": "01K4663BPWF1STEMMEMB5ZA2ET", "depth": 2, "invoke": {"state": "done", "status": "ok"}, "attempts": 1, "failures": 0, "startedAt": 1756849600167, "compensate": {"state": "dormant", "status": "idle"}, "definition": {"uuid": "01K4663BPWF1STEMMEMB5ZA2ET", "action": "validate", "noCompensation": false}, "stepFailed": false, "lastAttempt": 1756849600167, "saveResponse": true}, "_root.use-remote-query.validate.get-promotion-codes-to-apply": {"id": "_root.use-remote-query.validate.get-promotion-codes-to-apply", "next": ["_root.use-remote-query.validate.get-promotion-codes-to-apply.get-actions-to-compute-from-promotions"], "uuid": "01K4663BPWNP1JJ649CWB187D4", "depth": 3, "invoke": {"state": "done", "status": "ok"}, "attempts": 1, "failures": 0, "startedAt": 1756849600176, "compensate": {"state": "dormant", "status": "idle"}, "definition": {"uuid": "01K4663BPWNP1JJ649CWB187D4", "action": "get-promotion-codes-to-apply", "noCompensation": true}, "stepFailed": false, "lastAttempt": 1756849600176, "saveResponse": true}, "_root.use-remote-query.validate.get-promotion-codes-to-apply.get-actions-to-compute-from-promotions": {"id": "_root.use-remote-query.validate.get-promotion-codes-to-apply.get-actions-to-compute-from-promotions", "next": ["_root.use-remote-query.validate.get-promotion-codes-to-apply.get-actions-to-compute-from-promotions.prepare-adjustments-from-promotion-actions"], "uuid": "01K4663BPW33HWFHBD8XTNRGG7", "depth": 4, "invoke": {"state": "done", "status": "ok"}, "attempts": 1, "failures": 0, "startedAt": 1756849600183, "compensate": {"state": "dormant", "status": "idle"}, "definition": {"uuid": "01K4663BPW33HWFHBD8XTNRGG7", "action": "get-actions-to-compute-from-promotions", "noCompensation": true}, "stepFailed": false, "lastAttempt": 1756849600183, "saveResponse": true}, "_root.use-remote-query.validate.get-promotion-codes-to-apply.get-actions-to-compute-from-promotions.prepare-adjustments-from-promotion-actions": {"id": "_root.use-remote-query.validate.get-promotion-codes-to-apply.get-actions-to-compute-from-promotions.prepare-adjustments-from-promotion-actions", "next": ["_root.use-remote-query.validate.get-promotion-codes-to-apply.get-actions-to-compute-from-promotions.prepare-adjustments-from-promotion-actions.remove-line-item-adjustments", "_root.use-remote-query.validate.get-promotion-codes-to-apply.get-actions-to-compute-from-promotions.prepare-adjustments-from-promotion-actions.remove-shipping-method-adjustments", "_root.use-remote-query.validate.get-promotion-codes-to-apply.get-actions-to-compute-from-promotions.prepare-adjustments-from-promotion-actions.create-line-item-adjustments", "_root.use-remote-query.validate.get-promotion-codes-to-apply.get-actions-to-compute-from-promotions.prepare-adjustments-from-promotion-actions.create-shipping-method-adjustments", "_root.use-remote-query.validate.get-promotion-codes-to-apply.get-actions-to-compute-from-promotions.prepare-adjustments-from-promotion-actions.update-cart-promotions"], "uuid": "01K4663BPWXR6E017MP2BWN86H", "depth": 5, "invoke": {"state": "done", "status": "ok"}, "attempts": 1, "failures": 0, "startedAt": 1756849600208, "compensate": {"state": "dormant", "status": "idle"}, "definition": {"uuid": "01K4663BPWXR6E017MP2BWN86H", "action": "prepare-adjustments-from-promotion-actions", "noCompensation": true}, "stepFailed": false, "lastAttempt": 1756849600208, "saveResponse": true}, "_root.use-remote-query.validate.get-promotion-codes-to-apply.get-actions-to-compute-from-promotions.prepare-adjustments-from-promotion-actions.update-cart-promotions": {"id": "_root.use-remote-query.validate.get-promotion-codes-to-apply.get-actions-to-compute-from-promotions.prepare-adjustments-from-promotion-actions.update-cart-promotions", "next": [], "uuid": "01K4663BPX83CTJMH5APAJFEY9", "depth": 6, "invoke": {"state": "done", "status": "ok"}, "attempts": 1, "failures": 0, "startedAt": 1756849600219, "compensate": {"state": "dormant", "status": "idle"}, "definition": {"uuid": "01K4663BPX83CTJMH5APAJFEY9", "action": "update-cart-promotions", "noCompensation": false}, "stepFailed": false, "lastAttempt": 1756849600219, "saveResponse": true}, "_root.use-remote-query.validate.get-promotion-codes-to-apply.get-actions-to-compute-from-promotions.prepare-adjustments-from-promotion-actions.create-line-item-adjustments": {"id": "_root.use-remote-query.validate.get-promotion-codes-to-apply.get-actions-to-compute-from-promotions.prepare-adjustments-from-promotion-actions.create-line-item-adjustments", "next": [], "uuid": "01K4663BPXTE7HR1CC4QMS1XM5", "depth": 6, "invoke": {"state": "done", "status": "ok"}, "attempts": 1, "failures": 0, "startedAt": 1756849600219, "compensate": {"state": "dormant", "status": "idle"}, "definition": {"uuid": "01K4663BPXTE7HR1CC4QMS1XM5", "action": "create-line-item-adjustments", "noCompensation": false}, "stepFailed": false, "lastAttempt": 1756849600219, "saveResponse": true}, "_root.use-remote-query.validate.get-promotion-codes-to-apply.get-actions-to-compute-from-promotions.prepare-adjustments-from-promotion-actions.remove-line-item-adjustments": {"id": "_root.use-remote-query.validate.get-promotion-codes-to-apply.get-actions-to-compute-from-promotions.prepare-adjustments-from-promotion-actions.remove-line-item-adjustments", "next": [], "uuid": "01K4663BPW6S89PQ0WVR9K2Z35", "depth": 6, "invoke": {"state": "done", "status": "ok"}, "attempts": 1, "failures": 0, "startedAt": 1756849600219, "compensate": {"state": "dormant", "status": "idle"}, "definition": {"uuid": "01K4663BPW6S89PQ0WVR9K2Z35", "action": "remove-line-item-adjustments", "noCompensation": false}, "stepFailed": false, "lastAttempt": 1756849600219, "saveResponse": true}, "_root.use-remote-query.validate.get-promotion-codes-to-apply.get-actions-to-compute-from-promotions.prepare-adjustments-from-promotion-actions.create-shipping-method-adjustments": {"id": "_root.use-remote-query.validate.get-promotion-codes-to-apply.get-actions-to-compute-from-promotions.prepare-adjustments-from-promotion-actions.create-shipping-method-adjustments", "next": [], "uuid": "01K4663BPX0CYFSHY4ME8QRAE9", "depth": 6, "invoke": {"state": "done", "status": "ok"}, "attempts": 1, "failures": 0, "startedAt": 1756849600219, "compensate": {"state": "dormant", "status": "idle"}, "definition": {"uuid": "01K4663BPX0CYFSHY4ME8QRAE9", "action": "create-shipping-method-adjustments", "noCompensation": false}, "stepFailed": false, "lastAttempt": 1756849600219, "saveResponse": true}, "_root.use-remote-query.validate.get-promotion-codes-to-apply.get-actions-to-compute-from-promotions.prepare-adjustments-from-promotion-actions.remove-shipping-method-adjustments": {"id": "_root.use-remote-query.validate.get-promotion-codes-to-apply.get-actions-to-compute-from-promotions.prepare-adjustments-from-promotion-actions.remove-shipping-method-adjustments", "next": [], "uuid": "01K4663BPW2DK8NGJ4QXBJGJFP", "depth": 6, "invoke": {"state": "done", "status": "ok"}, "attempts": 1, "failures": 0, "startedAt": 1756849600219, "compensate": {"state": "dormant", "status": "idle"}, "definition": {"uuid": "01K4663BPW2DK8NGJ4QXBJGJFP", "action": "remove-shipping-method-adjustments", "noCompensation": false}, "stepFailed": false, "lastAttempt": 1756849600219, "saveResponse": true}}, "modelId": "update-cart-promotions", "options": {"name": "update-cart-promotions", "store": true, "idempotent": true}, "metadata": {"sourcePath": "/Users/mukul/Documents/GitHub/pharmint-marketplace/backend-fresh/node_modules/@medusajs/core-flows/dist/cart/workflows/update-cart-promotions.js", "eventGroupId": "01K466AXGTJ02G1TJ55EW06EDS", "preventReleaseEvents": true, "parentStepIdempotencyKey": "create-cart:auto-01K466AXGTYBSJHXWJ856CK0JD:update-cart-promotions-as-step:invoke"}, "startedAt": 1756849600096, "definition": {"next": {"next": {"next": {"next": {"next": [{"uuid": "01K4663BPW6S89PQ0WVR9K2Z35", "action": "remove-line-item-adjustments", "noCompensation": false}, {"uuid": "01K4663BPW2DK8NGJ4QXBJGJFP", "action": "remove-shipping-method-adjustments", "noCompensation": false}, {"uuid": "01K4663BPXTE7HR1CC4QMS1XM5", "action": "create-line-item-adjustments", "noCompensation": false}, {"uuid": "01K4663BPX0CYFSHY4ME8QRAE9", "action": "create-shipping-method-adjustments", "noCompensation": false}, {"uuid": "01K4663BPX83CTJMH5APAJFEY9", "action": "update-cart-promotions", "noCompensation": false}], "uuid": "01K4663BPWXR6E017MP2BWN86H", "action": "prepare-adjustments-from-promotion-actions", "noCompensation": true}, "uuid": "01K4663BPW33HWFHBD8XTNRGG7", "action": "get-actions-to-compute-from-promotions", "noCompensation": true}, "uuid": "01K4663BPWNP1JJ649CWB187D4", "action": "get-promotion-codes-to-apply", "noCompensation": true}, "uuid": "01K4663BPWF1STEMMEMB5ZA2ET", "action": "validate", "noCompensation": false}, "uuid": "01K4663BPWX35XJVDTWBF7WFQY", "action": "use-remote-query", "noCompensation": true}, "timedOutAt": null, "hasAsyncSteps": false, "transactionId": "update-cart-promotions-as-step-auto-01K466AXGTYBSJHXWJ856CK0JD", "hasFailedSteps": false, "hasSkippedSteps": false, "hasWaitingSteps": false, "hasRevertedSteps": false, "hasSkippedOnFailureSteps": false}	{"data": {"invoke": {"validate": {"__type": "Symbol(WorkflowWorkflowData)", "output": {"__type": "Symbol(WorkflowStepResponse)"}}, "use-remote-query": {"__type": "Symbol(WorkflowWorkflowData)", "output": {"__type": "Symbol(WorkflowStepResponse)", "output": {"id": "cart_01K466AXHFNSF95BC7REXFZ8B0", "items": [], "total": 0, "region": {"id": "reg_01K465NWZBB589QBS334WRK4PF", "name": "Europe", "metadata": null, "created_at": "2025-09-02T21:35:11.341Z", "deleted_at": null, "updated_at": "2025-09-02T21:35:11.341Z", "currency_code": "eur", "automatic_taxes": true}, "metadata": null, "subtotal": 0, "region_id": "reg_01K465NWZBB589QBS334WRK4PF", "item_total": 0, "promotions": [], "customer_id": null, "completed_at": null, "currency_code": "eur", "item_subtotal": 0, "sales_channel_id": "sc_01K465NVAAFMSJ0RGP5VCKEPVH", "shipping_methods": [], "shipping_subtotal": 0}, "compensateInput": {"id": "cart_01K466AXHFNSF95BC7REXFZ8B0", "items": [], "total": 0, "region": {"id": "reg_01K465NWZBB589QBS334WRK4PF", "name": "Europe", "metadata": null, "created_at": "2025-09-02T21:35:11.341Z", "deleted_at": null, "updated_at": "2025-09-02T21:35:11.341Z", "currency_code": "eur", "automatic_taxes": true}, "metadata": null, "subtotal": 0, "region_id": "reg_01K465NWZBB589QBS334WRK4PF", "item_total": 0, "promotions": [], "customer_id": null, "completed_at": null, "currency_code": "eur", "item_subtotal": 0, "sales_channel_id": "sc_01K465NVAAFMSJ0RGP5VCKEPVH", "shipping_methods": [], "shipping_subtotal": 0}}}, "update-cart-promotions": {"__type": "Symbol(WorkflowWorkflowData)", "output": {"__type": "Symbol(WorkflowStepResponse)", "output": null, "compensateInput": {"createdLinkIds": [], "dismissedLinks": []}}}, "create-line-item-adjustments": {"__type": "Symbol(WorkflowWorkflowData)", "output": {"__type": "Symbol(WorkflowStepResponse)", "output": [], "compensateInput": []}}, "get-promotion-codes-to-apply": {"__type": "Symbol(WorkflowWorkflowData)", "output": {"__type": "Symbol(WorkflowStepResponse)", "output": [], "compensateInput": []}}, "remove-line-item-adjustments": {"__type": "Symbol(WorkflowWorkflowData)", "output": {"__type": "Symbol(WorkflowStepResponse)", "compensateInput": []}}, "create-shipping-method-adjustments": {"__type": "Symbol(WorkflowWorkflowData)", "output": {"__type": "Symbol(WorkflowStepResponse)", "compensateInput": []}}, "remove-shipping-method-adjustments": {"__type": "Symbol(WorkflowWorkflowData)", "output": {"__type": "Symbol(WorkflowStepResponse)", "compensateInput": []}}, "get-actions-to-compute-from-promotions": {"__type": "Symbol(WorkflowWorkflowData)", "output": {"__type": "Symbol(WorkflowStepResponse)", "output": [], "compensateInput": []}}, "prepare-adjustments-from-promotion-actions": {"__type": "Symbol(WorkflowWorkflowData)", "output": {"__type": "Symbol(WorkflowStepResponse)", "output": {"computedPromotionCodes": [], "lineItemAdjustmentsToCreate": [], "lineItemAdjustmentIdsToRemove": [], "shippingMethodAdjustmentsToCreate": [], "shippingMethodAdjustmentIdsToRemove": []}, "compensateInput": {"computedPromotionCodes": [], "lineItemAdjustmentsToCreate": [], "lineItemAdjustmentIdsToRemove": [], "shippingMethodAdjustmentsToCreate": [], "shippingMethodAdjustmentIdsToRemove": []}}}}, "payload": {"cart_id": "cart_01K466AXHFNSF95BC7REXFZ8B0"}, "compensate": {}}, "errors": []}	done	2025-09-02 21:46:40.091	2025-09-02 21:46:40.235	\N	\N	01K466AXGXNZQMRNTR9DRXWM95
wf_exec_01K466AXQGS6HY2GNAV1DKCJZD	refresh-payment-collection-for-cart	refresh-payment-collection-for-cart-as-step-auto-01K466AXGTYBSJHXWJ856CK0JD	{"runId": "01K466AXGXNZQMRNTR9DRXWM95", "state": "done", "steps": {"_root": {"id": "_root", "next": ["_root.use-remote-query"]}, "_root.use-remote-query": {"id": "_root.use-remote-query", "next": ["_root.use-remote-query.validate"], "uuid": "01K4663BPWR9GVDT0VFKX4VD4G", "depth": 1, "invoke": {"state": "done", "status": "ok"}, "attempts": 1, "failures": 0, "startedAt": 1756849600246, "compensate": {"state": "dormant", "status": "idle"}, "definition": {"uuid": "01K4663BPWR9GVDT0VFKX4VD4G", "action": "use-remote-query", "noCompensation": true}, "stepFailed": false, "lastAttempt": 1756849600246, "saveResponse": true}, "_root.use-remote-query.validate": {"id": "_root.use-remote-query.validate", "next": ["_root.use-remote-query.validate.delete-payment-sessions-as-step", "_root.use-remote-query.validate.update-payment-collection"], "uuid": "01K4663BPW030HQQ5RWH303ZJ1", "depth": 2, "invoke": {"state": "done", "status": "ok"}, "attempts": 1, "failures": 0, "startedAt": 1756849600268, "compensate": {"state": "dormant", "status": "idle"}, "definition": {"uuid": "01K4663BPW030HQQ5RWH303ZJ1", "action": "validate", "noCompensation": false}, "stepFailed": false, "lastAttempt": 1756849600268, "saveResponse": true}, "_root.use-remote-query.validate.update-payment-collection": {"id": "_root.use-remote-query.validate.update-payment-collection", "next": [], "uuid": "01K4663BPWA5W884C9MBFT2FD3", "depth": 3, "invoke": {"state": "done", "status": "ok"}, "attempts": 1, "failures": 0, "startedAt": 1756849600287, "compensate": {"state": "dormant", "status": "idle"}, "definition": {"uuid": "01K4663BPWA5W884C9MBFT2FD3", "action": "update-payment-collection", "noCompensation": false}, "stepFailed": false, "lastAttempt": 1756849600287, "saveResponse": true}, "_root.use-remote-query.validate.delete-payment-sessions-as-step": {"id": "_root.use-remote-query.validate.delete-payment-sessions-as-step", "next": [], "uuid": "01K4663BPWYZANK6PDNKMVP4Z0", "depth": 3, "invoke": {"state": "done", "status": "ok"}, "attempts": 1, "failures": 0, "startedAt": 1756849600287, "compensate": {"state": "dormant", "status": "idle"}, "definition": {"name": "delete-payment-sessions-as-step", "uuid": "01K4663BPWYZANK6PDNKMVP4Z0", "async": false, "action": "delete-payment-sessions-as-step", "nested": false, "noCompensation": false}, "stepFailed": false, "lastAttempt": 1756849600287, "saveResponse": true}}, "modelId": "refresh-payment-collection-for-cart", "options": {"name": "refresh-payment-collection-for-cart", "store": true, "idempotent": true}, "metadata": {"sourcePath": "/Users/mukul/Documents/GitHub/pharmint-marketplace/backend-fresh/node_modules/@medusajs/core-flows/dist/cart/workflows/refresh-payment-collection.js", "eventGroupId": "01K466AXGTJ02G1TJ55EW06EDS", "preventReleaseEvents": true, "parentStepIdempotencyKey": "create-cart:auto-01K466AXGTYBSJHXWJ856CK0JD:refresh-payment-collection-for-cart-as-step:invoke"}, "startedAt": 1756849600242, "definition": {"next": {"next": [{"name": "delete-payment-sessions-as-step", "uuid": "01K4663BPWYZANK6PDNKMVP4Z0", "async": false, "action": "delete-payment-sessions-as-step", "nested": false, "noCompensation": false}, {"uuid": "01K4663BPWA5W884C9MBFT2FD3", "action": "update-payment-collection", "noCompensation": false}], "uuid": "01K4663BPW030HQQ5RWH303ZJ1", "action": "validate", "noCompensation": false}, "uuid": "01K4663BPWR9GVDT0VFKX4VD4G", "action": "use-remote-query", "noCompensation": true}, "timedOutAt": null, "hasAsyncSteps": false, "transactionId": "refresh-payment-collection-for-cart-as-step-auto-01K466AXGTYBSJHXWJ856CK0JD", "hasFailedSteps": false, "hasSkippedSteps": false, "hasWaitingSteps": false, "hasRevertedSteps": false, "hasSkippedOnFailureSteps": false}	{"data": {"invoke": {"validate": {"__type": "Symbol(WorkflowWorkflowData)", "output": {"__type": "Symbol(WorkflowStepResponse)"}}, "use-remote-query": {"__type": "Symbol(WorkflowWorkflowData)", "output": {"__type": "Symbol(WorkflowStepResponse)", "output": {"id": "cart_01K466AXHFNSF95BC7REXFZ8B0", "total": 0, "raw_total": {"value": "0", "precision": 20}, "region_id": "reg_01K465NWZBB589QBS334WRK4PF", "currency_code": "eur"}, "compensateInput": {"id": "cart_01K466AXHFNSF95BC7REXFZ8B0", "total": 0, "raw_total": {"value": "0", "precision": 20}, "region_id": "reg_01K465NWZBB589QBS334WRK4PF", "currency_code": "eur"}}}, "update-payment-collection": {"__type": "Symbol(WorkflowWorkflowData)", "output": {"__type": "Symbol(WorkflowStepResponse)", "output": [], "compensateInput": []}}, "delete-payment-sessions-as-step": {"__type": "Symbol(WorkflowWorkflowData)", "output": {"__type": "Symbol(WorkflowStepResponse)", "output": [], "compensateInput": {"errors": [], "result": [], "thrownError": null, "transaction": {"flow": {"runId": "01K466AXGXNZQMRNTR9DRXWM95", "state": "done", "steps": {"_root": {"id": "_root", "next": ["_root.delete-payment-sessions"]}, "_root.delete-payment-sessions": {"id": "_root.delete-payment-sessions", "next": ["_root.delete-payment-sessions.validate-deleted-payment-sessions"], "uuid": "01K4663BPT8A1R9099JQ3PXPZH", "depth": 1, "invoke": {"state": "done", "status": "ok"}, "attempts": 1, "failures": 0, "startedAt": 1756849600295, "compensate": {"state": "dormant", "status": "idle"}, "definition": {"uuid": "01K4663BPT8A1R9099JQ3PXPZH", "action": "delete-payment-sessions", "noCompensation": false}, "stepFailed": false, "lastAttempt": 1756849600295, "saveResponse": true}, "_root.delete-payment-sessions.validate-deleted-payment-sessions": {"id": "_root.delete-payment-sessions.validate-deleted-payment-sessions", "next": [], "uuid": "01K4663BPTCVRNEY0HPJB3VAF8", "depth": 2, "invoke": {"state": "done", "status": "ok"}, "attempts": 1, "failures": 0, "startedAt": 1756849600295, "compensate": {"state": "dormant", "status": "idle"}, "definition": {"uuid": "01K4663BPTCVRNEY0HPJB3VAF8", "action": "validate-deleted-payment-sessions", "noCompensation": true}, "stepFailed": false, "lastAttempt": 1756849600295, "saveResponse": true}}, "modelId": "delete-payment-sessions", "options": {}, "metadata": {"sourcePath": "/Users/mukul/Documents/GitHub/pharmint-marketplace/backend-fresh/node_modules/@medusajs/core-flows/dist/payment-collection/workflows/delete-payment-sessions.js", "eventGroupId": "01K466AXGTJ02G1TJ55EW06EDS", "preventReleaseEvents": true, "parentStepIdempotencyKey": "refresh-payment-collection-for-cart:refresh-payment-collection-for-cart-as-step-auto-01K466AXGTYBSJHXWJ856CK0JD:delete-payment-sessions-as-step:invoke"}, "startedAt": 1756849600295, "definition": {"next": {"uuid": "01K4663BPTCVRNEY0HPJB3VAF8", "action": "validate-deleted-payment-sessions", "noCompensation": true}, "uuid": "01K4663BPT8A1R9099JQ3PXPZH", "action": "delete-payment-sessions", "noCompensation": false}, "timedOutAt": null, "hasAsyncSteps": false, "transactionId": "delete-payment-sessions-as-step-refresh-payment-collection-for-cart-as-step-auto-01K466AXGTYBSJHXWJ856CK0JD", "hasFailedSteps": false, "hasSkippedSteps": false, "hasWaitingSteps": false, "hasRevertedSteps": false, "hasSkippedOnFailureSteps": false}, "runId": "01K466AXGXNZQMRNTR9DRXWM95", "errors": [], "_events": {}, "context": {"invoke": {"delete-payment-sessions": {"__type": "Symbol(WorkflowWorkflowData)", "output": {"__type": "Symbol(WorkflowStepResponse)", "output": [], "compensateInput": null}}, "validate-deleted-payment-sessions": {"__type": "Symbol(WorkflowWorkflowData)", "output": {"__type": "Symbol(WorkflowStepResponse)"}}}, "payload": {"ids": []}, "compensate": {}}, "modelId": "delete-payment-sessions", "payload": {"ids": []}, "_eventsCount": 0, "transactionId": "delete-payment-sessions-as-step-refresh-payment-collection-for-cart-as-step-auto-01K466AXGTYBSJHXWJ856CK0JD"}}}}}, "payload": {"cart_id": "cart_01K466AXHFNSF95BC7REXFZ8B0"}, "compensate": {}}, "errors": []}	done	2025-09-02 21:46:40.24	2025-09-02 21:46:40.303	\N	\N	01K466AXGXNZQMRNTR9DRXWM95
wf_exec_01K46A12WX71XN41J26D9YCP37	refresh-cart-items	refresh-cart-items-as-step-auto-01K46A12RDRJXRB1Y1TVQRHRSN	{"runId": "01K46A12RF3RVEMTWBR7A89T82", "state": "done", "steps": {"_root": {"id": "_root", "next": ["_root.setPricingContext"]}, "_root.setPricingContext": {"id": "_root.setPricingContext", "next": ["_root.setPricingContext.get-setPricingContext-result"], "uuid": "01K469C7N1Q59SKGPHT9QK2098", "depth": 1, "invoke": {"state": "done", "status": "ok"}, "attempts": 1, "failures": 0, "startedAt": 1756853472164, "compensate": {"state": "dormant", "status": "idle"}, "definition": {"uuid": "01K469C7N1Q59SKGPHT9QK2098", "action": "setPricingContext", "noCompensation": false}, "stepFailed": false, "lastAttempt": 1756853472164, "saveResponse": true}, "_root.setPricingContext.get-setPricingContext-result": {"id": "_root.setPricingContext.get-setPricingContext-result", "next": ["_root.setPricingContext.get-setPricingContext-result.use-query-graph-step"], "uuid": "01K469C7N1EHKNDDFFECVQKZ0A", "depth": 2, "invoke": {"state": "done", "status": "ok"}, "attempts": 1, "failures": 0, "startedAt": 1756853472171, "compensate": {"state": "dormant", "status": "idle"}, "definition": {"uuid": "01K469C7N1EHKNDDFFECVQKZ0A", "action": "get-setPricingContext-result", "noCompensation": false}, "stepFailed": false, "lastAttempt": 1756853472171, "saveResponse": true}, "_root.setPricingContext.get-setPricingContext-result.use-query-graph-step": {"id": "_root.setPricingContext.get-setPricingContext-result.use-query-graph-step", "next": ["_root.setPricingContext.get-setPricingContext-result.use-query-graph-step.fetch-variants"], "uuid": "01K469C7N20RKDSAJ08HM9WBW0", "depth": 3, "invoke": {"state": "skipped", "status": "ok"}, "attempts": 1, "failures": 0, "startedAt": 1756853472178, "compensate": {"state": "dormant", "status": "idle"}, "definition": {"uuid": "01K469C7N20RKDSAJ08HM9WBW0", "action": "use-query-graph-step", "noCompensation": true}, "stepFailed": false, "lastAttempt": 1756853472178, "saveResponse": true}, "_root.setPricingContext.get-setPricingContext-result.use-query-graph-step.fetch-variants": {"id": "_root.setPricingContext.get-setPricingContext-result.use-query-graph-step.fetch-variants", "next": ["_root.setPricingContext.get-setPricingContext-result.use-query-graph-step.fetch-variants.get-variant-price-sets"], "uuid": "01K469C7N29ANQW6VG18617DDW", "depth": 4, "invoke": {"state": "skipped", "status": "ok"}, "attempts": 1, "failures": 0, "startedAt": 1756853472187, "compensate": {"state": "dormant", "status": "idle"}, "definition": {"uuid": "01K469C7N29ANQW6VG18617DDW", "async": false, "action": "fetch-variants", "noCompensation": true, "compensateAsync": false}, "stepFailed": false, "lastAttempt": 1756853472187, "saveResponse": true}, "_root.setPricingContext.get-setPricingContext-result.use-query-graph-step.fetch-variants.get-variant-price-sets": {"id": "_root.setPricingContext.get-setPricingContext-result.use-query-graph-step.fetch-variants.get-variant-price-sets", "next": ["_root.setPricingContext.get-setPricingContext-result.use-query-graph-step.fetch-variants.get-variant-price-sets.validate-variant-prices"], "uuid": "01K469C7N248CY1ARY9DM0J4HR", "depth": 5, "invoke": {"state": "skipped", "status": "ok"}, "attempts": 1, "failures": 0, "startedAt": 1756853472194, "compensate": {"state": "dormant", "status": "idle"}, "definition": {"uuid": "01K469C7N248CY1ARY9DM0J4HR", "action": "get-variant-price-sets", "noCompensation": true}, "stepFailed": false, "lastAttempt": 1756853472194, "saveResponse": true}, "_root.setPricingContext.get-setPricingContext-result.use-query-graph-step.fetch-variants.get-variant-price-sets.validate-variant-prices": {"id": "_root.setPricingContext.get-setPricingContext-result.use-query-graph-step.fetch-variants.get-variant-price-sets.validate-variant-prices", "next": ["_root.setPricingContext.get-setPricingContext-result.use-query-graph-step.fetch-variants.get-variant-price-sets.validate-variant-prices.update-line-items-step"], "uuid": "01K469C7N2RJ0EENAPTVZA7Y5C", "depth": 6, "invoke": {"state": "skipped", "status": "ok"}, "attempts": 1, "failures": 0, "startedAt": 1756853472201, "compensate": {"state": "dormant", "status": "idle"}, "definition": {"uuid": "01K469C7N2RJ0EENAPTVZA7Y5C", "action": "validate-variant-prices", "noCompensation": true}, "stepFailed": false, "lastAttempt": 1756853472201, "saveResponse": true}, "_root.setPricingContext.get-setPricingContext-result.use-query-graph-step.fetch-variants.get-variant-price-sets.validate-variant-prices.update-line-items-step": {"id": "_root.setPricingContext.get-setPricingContext-result.use-query-graph-step.fetch-variants.get-variant-price-sets.validate-variant-prices.update-line-items-step", "next": ["_root.setPricingContext.get-setPricingContext-result.use-query-graph-step.fetch-variants.get-variant-price-sets.validate-variant-prices.update-line-items-step.refetch–cart"], "uuid": "01K469C7N2JYMCPRSS29R7R9F5", "depth": 7, "invoke": {"state": "skipped", "status": "ok"}, "attempts": 1, "failures": 0, "startedAt": 1756853472208, "compensate": {"state": "dormant", "status": "idle"}, "definition": {"uuid": "01K469C7N2JYMCPRSS29R7R9F5", "action": "update-line-items-step", "noCompensation": false}, "stepFailed": false, "lastAttempt": 1756853472208, "saveResponse": true}, "_root.setPricingContext.get-setPricingContext-result.use-query-graph-step.fetch-variants.get-variant-price-sets.validate-variant-prices.update-line-items-step.refetch–cart": {"id": "_root.setPricingContext.get-setPricingContext-result.use-query-graph-step.fetch-variants.get-variant-price-sets.validate-variant-prices.update-line-items-step.refetch–cart", "next": ["_root.setPricingContext.get-setPricingContext-result.use-query-graph-step.fetch-variants.get-variant-price-sets.validate-variant-prices.update-line-items-step.refetch–cart.refresh-cart-shipping-methods-as-step"], "uuid": "01K469C7N2KE5SFTWEYRT0AVJA", "depth": 8, "invoke": {"state": "done", "status": "ok"}, "attempts": 1, "failures": 0, "startedAt": 1756853472214, "compensate": {"state": "dormant", "status": "idle"}, "definition": {"uuid": "01K469C7N2KE5SFTWEYRT0AVJA", "async": false, "action": "refetch–cart", "noCompensation": true, "compensateAsync": false}, "stepFailed": false, "lastAttempt": 1756853472214, "saveResponse": true}, "_root.setPricingContext.get-setPricingContext-result.use-query-graph-step.fetch-variants.get-variant-price-sets.validate-variant-prices.update-line-items-step.refetch–cart.refresh-cart-shipping-methods-as-step": {"id": "_root.setPricingContext.get-setPricingContext-result.use-query-graph-step.fetch-variants.get-variant-price-sets.validate-variant-prices.update-line-items-step.refetch–cart.refresh-cart-shipping-methods-as-step", "next": ["_root.setPricingContext.get-setPricingContext-result.use-query-graph-step.fetch-variants.get-variant-price-sets.validate-variant-prices.update-line-items-step.refetch–cart.refresh-cart-shipping-methods-as-step.update-tax-lines-as-step"], "uuid": "01K469C7N2E4TE6VZ7Z202Q75B", "depth": 9, "invoke": {"state": "done", "status": "ok"}, "attempts": 1, "failures": 0, "startedAt": 1756853472249, "compensate": {"state": "dormant", "status": "idle"}, "definition": {"name": "refresh-cart-shipping-methods-as-step", "uuid": "01K469C7N2E4TE6VZ7Z202Q75B", "async": false, "action": "refresh-cart-shipping-methods-as-step", "nested": false, "noCompensation": false}, "stepFailed": false, "lastAttempt": 1756853472249, "saveResponse": true}, "_root.setPricingContext.get-setPricingContext-result.use-query-graph-step.fetch-variants.get-variant-price-sets.validate-variant-prices.update-line-items-step.refetch–cart.refresh-cart-shipping-methods-as-step.update-tax-lines-as-step": {"id": "_root.setPricingContext.get-setPricingContext-result.use-query-graph-step.fetch-variants.get-variant-price-sets.validate-variant-prices.update-line-items-step.refetch–cart.refresh-cart-shipping-methods-as-step.update-tax-lines-as-step", "next": ["_root.setPricingContext.get-setPricingContext-result.use-query-graph-step.fetch-variants.get-variant-price-sets.validate-variant-prices.update-line-items-step.refetch–cart.refresh-cart-shipping-methods-as-step.update-tax-lines-as-step.upsert-tax-lines-as-step"], "uuid": "01K469C7N2N77NK38FQMV20V39", "depth": 10, "invoke": {"state": "skipped", "status": "ok"}, "attempts": 1, "failures": 0, "startedAt": 1756853472356, "compensate": {"state": "dormant", "status": "idle"}, "definition": {"name": "update-tax-lines-as-step", "uuid": "01K469C7N2N77NK38FQMV20V39", "async": false, "action": "update-tax-lines-as-step", "nested": false, "noCompensation": false}, "stepFailed": false, "lastAttempt": 1756853472356, "saveResponse": true}, "_root.setPricingContext.get-setPricingContext-result.use-query-graph-step.fetch-variants.get-variant-price-sets.validate-variant-prices.update-line-items-step.refetch–cart.refresh-cart-shipping-methods-as-step.update-tax-lines-as-step.upsert-tax-lines-as-step": {"id": "_root.setPricingContext.get-setPricingContext-result.use-query-graph-step.fetch-variants.get-variant-price-sets.validate-variant-prices.update-line-items-step.refetch–cart.refresh-cart-shipping-methods-as-step.update-tax-lines-as-step.upsert-tax-lines-as-step", "next": ["_root.setPricingContext.get-setPricingContext-result.use-query-graph-step.fetch-variants.get-variant-price-sets.validate-variant-prices.update-line-items-step.refetch–cart.refresh-cart-shipping-methods-as-step.update-tax-lines-as-step.upsert-tax-lines-as-step.update-cart-promotions-as-step"], "uuid": "01K469C7N2CDCP58N46VYJ8DJE", "depth": 11, "invoke": {"state": "done", "status": "ok"}, "attempts": 1, "failures": 0, "startedAt": 1756853472378, "compensate": {"state": "dormant", "status": "idle"}, "definition": {"name": "upsert-tax-lines-as-step", "uuid": "01K469C7N2CDCP58N46VYJ8DJE", "async": false, "action": "upsert-tax-lines-as-step", "nested": false, "noCompensation": false}, "stepFailed": false, "lastAttempt": 1756853472378, "saveResponse": true}, "_root.setPricingContext.get-setPricingContext-result.use-query-graph-step.fetch-variants.get-variant-price-sets.validate-variant-prices.update-line-items-step.refetch–cart.refresh-cart-shipping-methods-as-step.update-tax-lines-as-step.upsert-tax-lines-as-step.update-cart-promotions-as-step": {"id": "_root.setPricingContext.get-setPricingContext-result.use-query-graph-step.fetch-variants.get-variant-price-sets.validate-variant-prices.update-line-items-step.refetch–cart.refresh-cart-shipping-methods-as-step.update-tax-lines-as-step.upsert-tax-lines-as-step.update-cart-promotions-as-step", "next": ["_root.setPricingContext.get-setPricingContext-result.use-query-graph-step.fetch-variants.get-variant-price-sets.validate-variant-prices.update-line-items-step.refetch–cart.refresh-cart-shipping-methods-as-step.update-tax-lines-as-step.upsert-tax-lines-as-step.update-cart-promotions-as-step.beforeRefreshingPaymentCollection"], "uuid": "01K469C7N21PWZHNXZNG209K3N", "depth": 12, "invoke": {"state": "done", "status": "ok"}, "attempts": 1, "failures": 0, "startedAt": 1756853472412, "compensate": {"state": "dormant", "status": "idle"}, "definition": {"name": "update-cart-promotions-as-step", "uuid": "01K469C7N21PWZHNXZNG209K3N", "async": false, "action": "update-cart-promotions-as-step", "nested": false, "noCompensation": false}, "stepFailed": false, "lastAttempt": 1756853472412, "saveResponse": true}, "_root.setPricingContext.get-setPricingContext-result.use-query-graph-step.fetch-variants.get-variant-price-sets.validate-variant-prices.update-line-items-step.refetch–cart.refresh-cart-shipping-methods-as-step.update-tax-lines-as-step.upsert-tax-lines-as-step.update-cart-promotions-as-step.beforeRefreshingPaymentCollection": {"id": "_root.setPricingContext.get-setPricingContext-result.use-query-graph-step.fetch-variants.get-variant-price-sets.validate-variant-prices.update-line-items-step.refetch–cart.refresh-cart-shipping-methods-as-step.update-tax-lines-as-step.upsert-tax-lines-as-step.update-cart-promotions-as-step.beforeRefreshingPaymentCollection", "next": ["_root.setPricingContext.get-setPricingContext-result.use-query-graph-step.fetch-variants.get-variant-price-sets.validate-variant-prices.update-line-items-step.refetch–cart.refresh-cart-shipping-methods-as-step.update-tax-lines-as-step.upsert-tax-lines-as-step.update-cart-promotions-as-step.beforeRefreshingPaymentCollection.refresh-payment-collection-for-cart-as-step"], "uuid": "01K469C7N2FW7VPTZZGKKBBDED", "depth": 13, "invoke": {"state": "done", "status": "ok"}, "attempts": 1, "failures": 0, "startedAt": 1756853472556, "compensate": {"state": "dormant", "status": "idle"}, "definition": {"uuid": "01K469C7N2FW7VPTZZGKKBBDED", "action": "beforeRefreshingPaymentCollection", "noCompensation": false}, "stepFailed": false, "lastAttempt": 1756853472556, "saveResponse": true}, "_root.setPricingContext.get-setPricingContext-result.use-query-graph-step.fetch-variants.get-variant-price-sets.validate-variant-prices.update-line-items-step.refetch–cart.refresh-cart-shipping-methods-as-step.update-tax-lines-as-step.upsert-tax-lines-as-step.update-cart-promotions-as-step.beforeRefreshingPaymentCollection.refresh-payment-collection-for-cart-as-step": {"id": "_root.setPricingContext.get-setPricingContext-result.use-query-graph-step.fetch-variants.get-variant-price-sets.validate-variant-prices.update-line-items-step.refetch–cart.refresh-cart-shipping-methods-as-step.update-tax-lines-as-step.upsert-tax-lines-as-step.update-cart-promotions-as-step.beforeRefreshingPaymentCollection.refresh-payment-collection-for-cart-as-step", "next": [], "uuid": "01K469C7N2JQ1T12SPWFDQ3JTN", "depth": 14, "invoke": {"state": "done", "status": "ok"}, "attempts": 1, "failures": 0, "startedAt": 1756853472590, "compensate": {"state": "dormant", "status": "idle"}, "definition": {"name": "refresh-payment-collection-for-cart-as-step", "uuid": "01K469C7N2JQ1T12SPWFDQ3JTN", "async": false, "action": "refresh-payment-collection-for-cart-as-step", "nested": false, "noCompensation": false}, "stepFailed": false, "lastAttempt": 1756853472590, "saveResponse": true}}, "modelId": "refresh-cart-items", "options": {"name": "refresh-cart-items", "store": true, "idempotent": true}, "metadata": {"sourcePath": "/Users/mukul/Documents/GitHub/pharmint-marketplace/backend/node_modules/@medusajs/core-flows/dist/cart/workflows/refresh-cart-items.js", "eventGroupId": "01K46A12RD5DTAJW3P0DEHRKZB", "preventReleaseEvents": true, "parentStepIdempotencyKey": "add-shipping-method-to-cart:auto-01K46A12RDRJXRB1Y1TVQRHRSN:refresh-cart-items-as-step:invoke"}, "startedAt": 1756853472160, "definition": {"next": {"next": {"next": {"next": {"next": {"next": {"next": {"next": {"name": "refresh-cart-shipping-methods-as-step", "next": {"name": "update-tax-lines-as-step", "next": {"name": "upsert-tax-lines-as-step", "next": {"name": "update-cart-promotions-as-step", "next": {"next": {"name": "refresh-payment-collection-for-cart-as-step", "uuid": "01K469C7N2JQ1T12SPWFDQ3JTN", "async": false, "action": "refresh-payment-collection-for-cart-as-step", "nested": false, "noCompensation": false}, "uuid": "01K469C7N2FW7VPTZZGKKBBDED", "action": "beforeRefreshingPaymentCollection", "noCompensation": false}, "uuid": "01K469C7N21PWZHNXZNG209K3N", "async": false, "action": "update-cart-promotions-as-step", "nested": false, "noCompensation": false}, "uuid": "01K469C7N2CDCP58N46VYJ8DJE", "async": false, "action": "upsert-tax-lines-as-step", "nested": false, "noCompensation": false}, "uuid": "01K469C7N2N77NK38FQMV20V39", "async": false, "action": "update-tax-lines-as-step", "nested": false, "noCompensation": false}, "uuid": "01K469C7N2E4TE6VZ7Z202Q75B", "async": false, "action": "refresh-cart-shipping-methods-as-step", "nested": false, "noCompensation": false}, "uuid": "01K469C7N2KE5SFTWEYRT0AVJA", "async": false, "action": "refetch–cart", "noCompensation": true, "compensateAsync": false}, "uuid": "01K469C7N2JYMCPRSS29R7R9F5", "action": "update-line-items-step", "noCompensation": false}, "uuid": "01K469C7N2RJ0EENAPTVZA7Y5C", "action": "validate-variant-prices", "noCompensation": true}, "uuid": "01K469C7N248CY1ARY9DM0J4HR", "action": "get-variant-price-sets", "noCompensation": true}, "uuid": "01K469C7N29ANQW6VG18617DDW", "async": false, "action": "fetch-variants", "noCompensation": true, "compensateAsync": false}, "uuid": "01K469C7N20RKDSAJ08HM9WBW0", "action": "use-query-graph-step", "noCompensation": true}, "uuid": "01K469C7N1EHKNDDFFECVQKZ0A", "action": "get-setPricingContext-result", "noCompensation": false}, "uuid": "01K469C7N1Q59SKGPHT9QK2098", "action": "setPricingContext", "noCompensation": false}, "timedOutAt": null, "hasAsyncSteps": false, "transactionId": "refresh-cart-items-as-step-auto-01K46A12RDRJXRB1Y1TVQRHRSN", "hasFailedSteps": false, "hasSkippedSteps": true, "hasWaitingSteps": false, "hasRevertedSteps": false, "hasSkippedOnFailureSteps": false}	{"data": {"invoke": {"refetch–cart": {"__type": "Symbol(WorkflowWorkflowData)", "output": {"__type": "Symbol(WorkflowStepResponse)", "output": {"id": "cart_01K466AXHFNSF95BC7REXFZ8B0", "items": [{"id": "cali_01K468ECQFE8SQKS9467B5AD66", "title": "Medusa T-Shirt", "total": 10, "cart_id": "cart_01K466AXHFNSF95BC7REXFZ8B0", "product": {"id": "prod_01K465NX26VFWW6C9Y3GJN3K6V", "tags": [], "type_id": null, "categories": [], "is_giftcard": false, "collection_id": null}, "variant": {"id": "variant_01K465NX36QVW4VT9ZBR1WEYPA", "width": null, "height": null, "length": null, "weight": null, "product": {"id": "prod_01K465NX26VFWW6C9Y3GJN3K6V"}, "material": null, "product_id": "prod_01K465NX26VFWW6C9Y3GJN3K6V"}, "metadata": {}, "quantity": 1, "subtitle": "M / Black", "subtotal": 10, "raw_total": {"value": "10", "precision": 20}, "tax_lines": [], "tax_total": 0, "thumbnail": "https://medusa-public-images.s3.eu-west-1.amazonaws.com/tee-black-front.png", "created_at": "2025-09-02T22:23:31.055Z", "deleted_at": null, "product_id": "prod_01K465NX26VFWW6C9Y3GJN3K6V", "unit_price": 10, "updated_at": "2025-09-02T22:23:31.055Z", "variant_id": "variant_01K465NX36QVW4VT9ZBR1WEYPA", "adjustments": [], "is_giftcard": false, "variant_sku": "SHIRT-M-BLACK", "product_type": null, "raw_subtotal": {"value": "10", "precision": 20}, "product_title": "Medusa T-Shirt", "raw_tax_total": {"value": "0", "precision": 20}, "variant_title": "M / Black", "discount_total": 0, "original_total": 10, "product_handle": "t-shirt", "raw_unit_price": {"value": "10", "precision": 20}, "is_custom_price": false, "is_discountable": true, "product_type_id": null, "variant_barcode": null, "is_tax_inclusive": false, "product_subtitle": null, "discount_subtotal": 0, "requires_shipping": true, "discount_tax_total": 0, "original_tax_total": 0, "product_collection": null, "raw_discount_total": {"value": "0", "precision": 20}, "raw_original_total": {"value": "10", "precision": 20}, "product_description": "Reimagine the feeling of a classic T-shirt. With our cotton T-shirts, everyday essentials no longer have to be ordinary.", "compare_at_unit_price": null, "raw_discount_subtotal": {"value": "0", "precision": 20}, "variant_option_values": null, "raw_discount_tax_total": {"value": "0", "precision": 20}, "raw_original_tax_total": {"value": "0", "precision": 20}, "raw_compare_at_unit_price": null}], "total": 20, "region": {"id": "reg_01K465NWZBB589QBS334WRK4PF", "name": "Europe", "metadata": null, "created_at": "2025-09-02T21:35:11.341Z", "deleted_at": null, "updated_at": "2025-09-02T21:35:11.341Z", "currency_code": "eur", "automatic_taxes": true}, "customer": {"id": "cus_01K46A0ZPRWKCSMQAW51DY0W8R", "email": "mk@mk.com", "phone": null, "groups": [], "metadata": null, "last_name": null, "created_at": "2025-09-02T22:51:08.888Z", "created_by": null, "deleted_at": null, "first_name": null, "updated_at": "2025-09-02T22:51:08.888Z", "has_account": false, "company_name": null}, "metadata": null, "subtotal": 20, "region_id": "reg_01K465NWZBB589QBS334WRK4PF", "item_total": 10, "promotions": [], "customer_id": "cus_01K46A0ZPRWKCSMQAW51DY0W8R", "completed_at": null, "currency_code": "eur", "item_subtotal": 10, "sales_channel_id": "sc_01K465NVAAFMSJ0RGP5VCKEPVH", "shipping_address": {"id": "caaddr_01K46A0ZRNPRJP2YKVVCX2RH5W", "city": "varanasi", "phone": "", "company": "", "metadata": null, "province": "up", "address_1": "test", "address_2": "", "last_name": "test", "created_at": "2025-09-02T22:51:08.950Z", "deleted_at": null, "first_name": "test", "updated_at": "2025-09-02T22:51:08.950Z", "customer_id": null, "postal_code": "221002", "country_code": "it"}, "shipping_methods": [{"id": "casm_01K46A12WMTEF0WW2GPAESHJ3N", "data": {}, "name": "Standard Shipping", "total": 10, "amount": 10, "cart_id": "cart_01K466AXHFNSF95BC7REXFZ8B0", "metadata": null, "subtotal": 10, "raw_total": {"value": "10", "precision": 20}, "tax_lines": [], "tax_total": 0, "created_at": "2025-09-02T22:51:12.148Z", "deleted_at": null, "raw_amount": {"value": "10", "precision": 20}, "updated_at": "2025-09-02T22:51:12.148Z", "adjustments": [], "description": null, "raw_subtotal": {"value": "10", "precision": 20}, "raw_tax_total": {"value": "0", "precision": 20}, "discount_total": 0, "original_total": 10, "shipping_option": {"id": "so_01K465NX0W8FHES8P37CAFHZS3", "shipping_option_type_id": "sotype_01K465NX0WGE47H7NC6TPMQ1VT"}, "is_tax_inclusive": false, "discount_subtotal": 0, "discount_tax_total": 0, "original_tax_total": 0, "raw_discount_total": {"value": "0", "precision": 20}, "raw_original_total": {"value": "10", "precision": 20}, "shipping_option_id": "so_01K465NX0W8FHES8P37CAFHZS3", "raw_discount_subtotal": {"value": "0", "precision": 20}, "raw_discount_tax_total": {"value": "0", "precision": 20}, "raw_original_tax_total": {"value": "0", "precision": 20}}], "shipping_subtotal": 10}, "compensateInput": {"id": "cart_01K466AXHFNSF95BC7REXFZ8B0", "items": [{"id": "cali_01K468ECQFE8SQKS9467B5AD66", "title": "Medusa T-Shirt", "total": 10, "cart_id": "cart_01K466AXHFNSF95BC7REXFZ8B0", "product": {"id": "prod_01K465NX26VFWW6C9Y3GJN3K6V", "tags": [], "type_id": null, "categories": [], "is_giftcard": false, "collection_id": null}, "variant": {"id": "variant_01K465NX36QVW4VT9ZBR1WEYPA", "width": null, "height": null, "length": null, "weight": null, "product": {"id": "prod_01K465NX26VFWW6C9Y3GJN3K6V"}, "material": null, "product_id": "prod_01K465NX26VFWW6C9Y3GJN3K6V"}, "metadata": {}, "quantity": 1, "subtitle": "M / Black", "subtotal": 10, "raw_total": {"value": "10", "precision": 20}, "tax_lines": [], "tax_total": 0, "thumbnail": "https://medusa-public-images.s3.eu-west-1.amazonaws.com/tee-black-front.png", "created_at": "2025-09-02T22:23:31.055Z", "deleted_at": null, "product_id": "prod_01K465NX26VFWW6C9Y3GJN3K6V", "unit_price": 10, "updated_at": "2025-09-02T22:23:31.055Z", "variant_id": "variant_01K465NX36QVW4VT9ZBR1WEYPA", "adjustments": [], "is_giftcard": false, "variant_sku": "SHIRT-M-BLACK", "product_type": null, "raw_subtotal": {"value": "10", "precision": 20}, "product_title": "Medusa T-Shirt", "raw_tax_total": {"value": "0", "precision": 20}, "variant_title": "M / Black", "discount_total": 0, "original_total": 10, "product_handle": "t-shirt", "raw_unit_price": {"value": "10", "precision": 20}, "is_custom_price": false, "is_discountable": true, "product_type_id": null, "variant_barcode": null, "is_tax_inclusive": false, "product_subtitle": null, "discount_subtotal": 0, "requires_shipping": true, "discount_tax_total": 0, "original_tax_total": 0, "product_collection": null, "raw_discount_total": {"value": "0", "precision": 20}, "raw_original_total": {"value": "10", "precision": 20}, "product_description": "Reimagine the feeling of a classic T-shirt. With our cotton T-shirts, everyday essentials no longer have to be ordinary.", "compare_at_unit_price": null, "raw_discount_subtotal": {"value": "0", "precision": 20}, "variant_option_values": null, "raw_discount_tax_total": {"value": "0", "precision": 20}, "raw_original_tax_total": {"value": "0", "precision": 20}, "raw_compare_at_unit_price": null}], "total": 20, "region": {"id": "reg_01K465NWZBB589QBS334WRK4PF", "name": "Europe", "metadata": null, "created_at": "2025-09-02T21:35:11.341Z", "deleted_at": null, "updated_at": "2025-09-02T21:35:11.341Z", "currency_code": "eur", "automatic_taxes": true}, "customer": {"id": "cus_01K46A0ZPRWKCSMQAW51DY0W8R", "email": "mk@mk.com", "phone": null, "groups": [], "metadata": null, "last_name": null, "created_at": "2025-09-02T22:51:08.888Z", "created_by": null, "deleted_at": null, "first_name": null, "updated_at": "2025-09-02T22:51:08.888Z", "has_account": false, "company_name": null}, "metadata": null, "subtotal": 20, "region_id": "reg_01K465NWZBB589QBS334WRK4PF", "item_total": 10, "promotions": [], "customer_id": "cus_01K46A0ZPRWKCSMQAW51DY0W8R", "completed_at": null, "currency_code": "eur", "item_subtotal": 10, "sales_channel_id": "sc_01K465NVAAFMSJ0RGP5VCKEPVH", "shipping_address": {"id": "caaddr_01K46A0ZRNPRJP2YKVVCX2RH5W", "city": "varanasi", "phone": "", "company": "", "metadata": null, "province": "up", "address_1": "test", "address_2": "", "last_name": "test", "created_at": "2025-09-02T22:51:08.950Z", "deleted_at": null, "first_name": "test", "updated_at": "2025-09-02T22:51:08.950Z", "customer_id": null, "postal_code": "221002", "country_code": "it"}, "shipping_methods": [{"id": "casm_01K46A12WMTEF0WW2GPAESHJ3N", "data": {}, "name": "Standard Shipping", "total": 10, "amount": 10, "cart_id": "cart_01K466AXHFNSF95BC7REXFZ8B0", "metadata": null, "subtotal": 10, "raw_total": {"value": "10", "precision": 20}, "tax_lines": [], "tax_total": 0, "created_at": "2025-09-02T22:51:12.148Z", "deleted_at": null, "raw_amount": {"value": "10", "precision": 20}, "updated_at": "2025-09-02T22:51:12.148Z", "adjustments": [], "description": null, "raw_subtotal": {"value": "10", "precision": 20}, "raw_tax_total": {"value": "0", "precision": 20}, "discount_total": 0, "original_total": 10, "shipping_option": {"id": "so_01K465NX0W8FHES8P37CAFHZS3", "shipping_option_type_id": "sotype_01K465NX0WGE47H7NC6TPMQ1VT"}, "is_tax_inclusive": false, "discount_subtotal": 0, "discount_tax_total": 0, "original_tax_total": 0, "raw_discount_total": {"value": "0", "precision": 20}, "raw_original_total": {"value": "10", "precision": 20}, "shipping_option_id": "so_01K465NX0W8FHES8P37CAFHZS3", "raw_discount_subtotal": {"value": "0", "precision": 20}, "raw_discount_tax_total": {"value": "0", "precision": 20}, "raw_original_tax_total": {"value": "0", "precision": 20}}], "shipping_subtotal": 10}}}, "setPricingContext": {"__type": "Symbol(WorkflowWorkflowData)", "output": {"__type": "Symbol(WorkflowStepResponse)"}}, "upsert-tax-lines-as-step": {"__type": "Symbol(WorkflowWorkflowData)", "output": {"__type": "Symbol(WorkflowStepResponse)", "compensateInput": {"errors": [], "thrownError": null, "transaction": {"flow": {"runId": "01K46A12RF3RVEMTWBR7A89T82", "state": "done", "steps": {"_root": {"id": "_root", "next": ["_root.use-remote-query"]}, "_root.use-remote-query": {"id": "_root.use-remote-query", "next": ["_root.use-remote-query.get-item-tax-lines"], "uuid": "01K469C7N1SF64WHCGEX0ES8VK", "depth": 1, "invoke": {"state": "skipped", "status": "ok"}, "attempts": 1, "failures": 0, "startedAt": 1756853472390, "compensate": {"state": "dormant", "status": "idle"}, "definition": {"uuid": "01K469C7N1SF64WHCGEX0ES8VK", "action": "use-remote-query", "noCompensation": true}, "stepFailed": false, "lastAttempt": 1756853472390, "saveResponse": true}, "_root.use-remote-query.get-item-tax-lines": {"id": "_root.use-remote-query.get-item-tax-lines", "next": ["_root.use-remote-query.get-item-tax-lines.set-tax-lines-for-items"], "uuid": "01K469C7N1GP1CQH7TVQ56STHC", "depth": 2, "invoke": {"state": "done", "status": "ok"}, "attempts": 1, "failures": 0, "startedAt": 1756853472391, "compensate": {"state": "dormant", "status": "idle"}, "definition": {"uuid": "01K469C7N1GP1CQH7TVQ56STHC", "action": "get-item-tax-lines", "noCompensation": true}, "stepFailed": false, "lastAttempt": 1756853472391, "saveResponse": true}, "_root.use-remote-query.get-item-tax-lines.set-tax-lines-for-items": {"id": "_root.use-remote-query.get-item-tax-lines.set-tax-lines-for-items", "next": [], "uuid": "01K469C7N1S7Q00DB9R5DGF6RR", "depth": 3, "invoke": {"state": "done", "status": "ok"}, "attempts": 1, "failures": 0, "startedAt": 1756853472399, "compensate": {"state": "dormant", "status": "idle"}, "definition": {"uuid": "01K469C7N1S7Q00DB9R5DGF6RR", "action": "set-tax-lines-for-items", "noCompensation": false}, "stepFailed": false, "lastAttempt": 1756853472399, "saveResponse": true}}, "modelId": "upsert-tax-lines", "options": {}, "metadata": {"sourcePath": "/Users/mukul/Documents/GitHub/pharmint-marketplace/backend/node_modules/@medusajs/core-flows/dist/cart/workflows/upsert-tax-lines.js", "eventGroupId": "01K46A12RD5DTAJW3P0DEHRKZB", "preventReleaseEvents": true, "parentStepIdempotencyKey": "refresh-cart-items:refresh-cart-items-as-step-auto-01K46A12RDRJXRB1Y1TVQRHRSN:upsert-tax-lines-as-step:invoke"}, "startedAt": 1756853472390, "definition": {"next": {"next": {"uuid": "01K469C7N1S7Q00DB9R5DGF6RR", "action": "set-tax-lines-for-items", "noCompensation": false}, "uuid": "01K469C7N1GP1CQH7TVQ56STHC", "action": "get-item-tax-lines", "noCompensation": true}, "uuid": "01K469C7N1SF64WHCGEX0ES8VK", "action": "use-remote-query", "noCompensation": true}, "timedOutAt": null, "hasAsyncSteps": false, "transactionId": "upsert-tax-lines-as-step-refresh-cart-items-as-step-auto-01K46A12RDRJXRB1Y1TVQRHRSN", "hasFailedSteps": false, "hasSkippedSteps": true, "hasWaitingSteps": false, "hasRevertedSteps": false, "hasSkippedOnFailureSteps": false}, "runId": "01K46A12RF3RVEMTWBR7A89T82", "errors": [], "_events": {}, "context": {"invoke": {"get-item-tax-lines": {"__type": "Symbol(WorkflowWorkflowData)", "output": {"__type": "Symbol(WorkflowStepResponse)", "output": {"lineItemTaxLines": [], "shippingMethodsTaxLines": []}, "compensateInput": {"lineItemTaxLines": [], "shippingMethodsTaxLines": []}}}, "set-tax-lines-for-items": {"__type": "Symbol(WorkflowWorkflowData)", "output": {"__type": "Symbol(WorkflowStepResponse)", "output": null, "compensateInput": {"cart": {"id": "cart_01K466AXHFNSF95BC7REXFZ8B0", "items": [{"id": "cali_01K468ECQFE8SQKS9467B5AD66", "title": "Medusa T-Shirt", "total": 10, "cart_id": "cart_01K466AXHFNSF95BC7REXFZ8B0", "product": {"id": "prod_01K465NX26VFWW6C9Y3GJN3K6V", "tags": [], "type_id": null, "categories": [], "is_giftcard": false, "collection_id": null}, "variant": {"id": "variant_01K465NX36QVW4VT9ZBR1WEYPA", "width": null, "height": null, "length": null, "weight": null, "product": {"id": "prod_01K465NX26VFWW6C9Y3GJN3K6V"}, "material": null, "product_id": "prod_01K465NX26VFWW6C9Y3GJN3K6V"}, "metadata": {}, "quantity": 1, "subtitle": "M / Black", "subtotal": 10, "raw_total": {"value": "10", "precision": 20}, "tax_lines": [], "tax_total": 0, "thumbnail": "https://medusa-public-images.s3.eu-west-1.amazonaws.com/tee-black-front.png", "created_at": "2025-09-02T22:23:31.055Z", "deleted_at": null, "product_id": "prod_01K465NX26VFWW6C9Y3GJN3K6V", "unit_price": 10, "updated_at": "2025-09-02T22:23:31.055Z", "variant_id": "variant_01K465NX36QVW4VT9ZBR1WEYPA", "adjustments": [], "is_giftcard": false, "variant_sku": "SHIRT-M-BLACK", "product_type": null, "raw_subtotal": {"value": "10", "precision": 20}, "product_title": "Medusa T-Shirt", "raw_tax_total": {"value": "0", "precision": 20}, "variant_title": "M / Black", "discount_total": 0, "original_total": 10, "product_handle": "t-shirt", "raw_unit_price": {"value": "10", "precision": 20}, "is_custom_price": false, "is_discountable": true, "product_type_id": null, "variant_barcode": null, "is_tax_inclusive": false, "product_subtitle": null, "discount_subtotal": 0, "requires_shipping": true, "discount_tax_total": 0, "original_tax_total": 0, "product_collection": null, "raw_discount_total": {"value": "0", "precision": 20}, "raw_original_total": {"value": "10", "precision": 20}, "product_description": "Reimagine the feeling of a classic T-shirt. With our cotton T-shirts, everyday essentials no longer have to be ordinary.", "compare_at_unit_price": null, "raw_discount_subtotal": {"value": "0", "precision": 20}, "variant_option_values": null, "raw_discount_tax_total": {"value": "0", "precision": 20}, "raw_original_tax_total": {"value": "0", "precision": 20}, "raw_compare_at_unit_price": null}], "total": 20, "region": {"id": "reg_01K465NWZBB589QBS334WRK4PF", "name": "Europe", "metadata": null, "created_at": "2025-09-02T21:35:11.341Z", "deleted_at": null, "updated_at": "2025-09-02T21:35:11.341Z", "currency_code": "eur", "automatic_taxes": true}, "customer": {"id": "cus_01K46A0ZPRWKCSMQAW51DY0W8R", "email": "mk@mk.com", "phone": null, "groups": [], "metadata": null, "last_name": null, "created_at": "2025-09-02T22:51:08.888Z", "created_by": null, "deleted_at": null, "first_name": null, "updated_at": "2025-09-02T22:51:08.888Z", "has_account": false, "company_name": null}, "metadata": null, "subtotal": 20, "region_id": "reg_01K465NWZBB589QBS334WRK4PF", "item_total": 10, "promotions": [], "customer_id": "cus_01K46A0ZPRWKCSMQAW51DY0W8R", "completed_at": null, "currency_code": "eur", "item_subtotal": 10, "sales_channel_id": "sc_01K465NVAAFMSJ0RGP5VCKEPVH", "shipping_address": {"id": "caaddr_01K46A0ZRNPRJP2YKVVCX2RH5W", "city": "varanasi", "phone": "", "company": "", "metadata": null, "province": "up", "address_1": "test", "address_2": "", "last_name": "test", "created_at": "2025-09-02T22:51:08.950Z", "deleted_at": null, "first_name": "test", "updated_at": "2025-09-02T22:51:08.950Z", "customer_id": null, "postal_code": "221002", "country_code": "it"}, "shipping_methods": [{"id": "casm_01K46A12WMTEF0WW2GPAESHJ3N", "data": {}, "name": "Standard Shipping", "total": 10, "amount": 10, "cart_id": "cart_01K466AXHFNSF95BC7REXFZ8B0", "metadata": null, "subtotal": 10, "raw_total": {"value": "10", "precision": 20}, "tax_lines": [], "tax_total": 0, "created_at": "2025-09-02T22:51:12.148Z", "deleted_at": null, "raw_amount": {"value": "10", "precision": 20}, "updated_at": "2025-09-02T22:51:12.148Z", "adjustments": [], "description": null, "raw_subtotal": {"value": "10", "precision": 20}, "raw_tax_total": {"value": "0", "precision": 20}, "discount_total": 0, "original_total": 10, "shipping_option": {"id": "so_01K465NX0W8FHES8P37CAFHZS3", "shipping_option_type_id": "sotype_01K465NX0WGE47H7NC6TPMQ1VT"}, "is_tax_inclusive": false, "discount_subtotal": 0, "discount_tax_total": 0, "original_tax_total": 0, "raw_discount_total": {"value": "0", "precision": 20}, "raw_original_total": {"value": "10", "precision": 20}, "shipping_option_id": "so_01K465NX0W8FHES8P37CAFHZS3", "raw_discount_subtotal": {"value": "0", "precision": 20}, "raw_discount_tax_total": {"value": "0", "precision": 20}, "raw_original_tax_total": {"value": "0", "precision": 20}}], "shipping_subtotal": 10}, "existingLineItemTaxLines": [], "existingShippingMethodTaxLines": []}}}}, "payload": {"cart": {"id": "cart_01K466AXHFNSF95BC7REXFZ8B0", "items": [{"id": "cali_01K468ECQFE8SQKS9467B5AD66", "title": "Medusa T-Shirt", "total": 10, "cart_id": "cart_01K466AXHFNSF95BC7REXFZ8B0", "product": {"id": "prod_01K465NX26VFWW6C9Y3GJN3K6V", "tags": [], "type_id": null, "categories": [], "is_giftcard": false, "collection_id": null}, "variant": {"id": "variant_01K465NX36QVW4VT9ZBR1WEYPA", "width": null, "height": null, "length": null, "weight": null, "product": {"id": "prod_01K465NX26VFWW6C9Y3GJN3K6V"}, "material": null, "product_id": "prod_01K465NX26VFWW6C9Y3GJN3K6V"}, "metadata": {}, "quantity": 1, "subtitle": "M / Black", "subtotal": 10, "raw_total": {"value": "10", "precision": 20}, "tax_lines": [], "tax_total": 0, "thumbnail": "https://medusa-public-images.s3.eu-west-1.amazonaws.com/tee-black-front.png", "created_at": "2025-09-02T22:23:31.055Z", "deleted_at": null, "product_id": "prod_01K465NX26VFWW6C9Y3GJN3K6V", "unit_price": 10, "updated_at": "2025-09-02T22:23:31.055Z", "variant_id": "variant_01K465NX36QVW4VT9ZBR1WEYPA", "adjustments": [], "is_giftcard": false, "variant_sku": "SHIRT-M-BLACK", "product_type": null, "raw_subtotal": {"value": "10", "precision": 20}, "product_title": "Medusa T-Shirt", "raw_tax_total": {"value": "0", "precision": 20}, "variant_title": "M / Black", "discount_total": 0, "original_total": 10, "product_handle": "t-shirt", "raw_unit_price": {"value": "10", "precision": 20}, "is_custom_price": false, "is_discountable": true, "product_type_id": null, "variant_barcode": null, "is_tax_inclusive": false, "product_subtitle": null, "discount_subtotal": 0, "requires_shipping": true, "discount_tax_total": 0, "original_tax_total": 0, "product_collection": null, "raw_discount_total": {"value": "0", "precision": 20}, "raw_original_total": {"value": "10", "precision": 20}, "product_description": "Reimagine the feeling of a classic T-shirt. With our cotton T-shirts, everyday essentials no longer have to be ordinary.", "compare_at_unit_price": null, "raw_discount_subtotal": {"value": "0", "precision": 20}, "variant_option_values": null, "raw_discount_tax_total": {"value": "0", "precision": 20}, "raw_original_tax_total": {"value": "0", "precision": 20}, "raw_compare_at_unit_price": null}], "total": 20, "region": {"id": "reg_01K465NWZBB589QBS334WRK4PF", "name": "Europe", "metadata": null, "created_at": "2025-09-02T21:35:11.341Z", "deleted_at": null, "updated_at": "2025-09-02T21:35:11.341Z", "currency_code": "eur", "automatic_taxes": true}, "customer": {"id": "cus_01K46A0ZPRWKCSMQAW51DY0W8R", "email": "mk@mk.com", "phone": null, "groups": [], "metadata": null, "last_name": null, "created_at": "2025-09-02T22:51:08.888Z", "created_by": null, "deleted_at": null, "first_name": null, "updated_at": "2025-09-02T22:51:08.888Z", "has_account": false, "company_name": null}, "metadata": null, "subtotal": 20, "region_id": "reg_01K465NWZBB589QBS334WRK4PF", "item_total": 10, "promotions": [], "customer_id": "cus_01K46A0ZPRWKCSMQAW51DY0W8R", "completed_at": null, "currency_code": "eur", "item_subtotal": 10, "sales_channel_id": "sc_01K465NVAAFMSJ0RGP5VCKEPVH", "shipping_address": {"id": "caaddr_01K46A0ZRNPRJP2YKVVCX2RH5W", "city": "varanasi", "phone": "", "company": "", "metadata": null, "province": "up", "address_1": "test", "address_2": "", "last_name": "test", "created_at": "2025-09-02T22:51:08.950Z", "deleted_at": null, "first_name": "test", "updated_at": "2025-09-02T22:51:08.950Z", "customer_id": null, "postal_code": "221002", "country_code": "it"}, "shipping_methods": [{"id": "casm_01K46A12WMTEF0WW2GPAESHJ3N", "data": {}, "name": "Standard Shipping", "total": 10, "amount": 10, "cart_id": "cart_01K466AXHFNSF95BC7REXFZ8B0", "metadata": null, "subtotal": 10, "raw_total": {"value": "10", "precision": 20}, "tax_lines": [], "tax_total": 0, "created_at": "2025-09-02T22:51:12.148Z", "deleted_at": null, "raw_amount": {"value": "10", "precision": 20}, "updated_at": "2025-09-02T22:51:12.148Z", "adjustments": [], "description": null, "raw_subtotal": {"value": "10", "precision": 20}, "raw_tax_total": {"value": "0", "precision": 20}, "discount_total": 0, "original_total": 10, "shipping_option": {"id": "so_01K465NX0W8FHES8P37CAFHZS3", "shipping_option_type_id": "sotype_01K465NX0WGE47H7NC6TPMQ1VT"}, "is_tax_inclusive": false, "discount_subtotal": 0, "discount_tax_total": 0, "original_tax_total": 0, "raw_discount_total": {"value": "0", "precision": 20}, "raw_original_total": {"value": "10", "precision": 20}, "shipping_option_id": "so_01K465NX0W8FHES8P37CAFHZS3", "raw_discount_subtotal": {"value": "0", "precision": 20}, "raw_discount_tax_total": {"value": "0", "precision": 20}, "raw_original_tax_total": {"value": "0", "precision": 20}}], "shipping_subtotal": 10}, "items": [], "shipping_methods": [{"id": "casm_01K46A12WMTEF0WW2GPAESHJ3N", "data": {}, "name": "Standard Shipping", "amount": 10, "cart_id": "cart_01K466AXHFNSF95BC7REXFZ8B0", "metadata": null, "tax_lines": [], "created_at": "2025-09-02T22:51:12.148Z", "deleted_at": null, "raw_amount": {"value": "10", "precision": 20}, "updated_at": "2025-09-02T22:51:12.148Z", "adjustments": [], "description": null, "is_tax_inclusive": false, "shipping_option_id": "so_01K465NX0W8FHES8P37CAFHZS3"}]}, "compensate": {}}, "modelId": "upsert-tax-lines", "payload": {"cart": {"id": "cart_01K466AXHFNSF95BC7REXFZ8B0", "items": [{"id": "cali_01K468ECQFE8SQKS9467B5AD66", "title": "Medusa T-Shirt", "total": 10, "cart_id": "cart_01K466AXHFNSF95BC7REXFZ8B0", "product": {"id": "prod_01K465NX26VFWW6C9Y3GJN3K6V", "tags": [], "type_id": null, "categories": [], "is_giftcard": false, "collection_id": null}, "variant": {"id": "variant_01K465NX36QVW4VT9ZBR1WEYPA", "width": null, "height": null, "length": null, "weight": null, "product": {"id": "prod_01K465NX26VFWW6C9Y3GJN3K6V"}, "material": null, "product_id": "prod_01K465NX26VFWW6C9Y3GJN3K6V"}, "metadata": {}, "quantity": 1, "subtitle": "M / Black", "subtotal": 10, "raw_total": {"value": "10", "precision": 20}, "tax_lines": [], "tax_total": 0, "thumbnail": "https://medusa-public-images.s3.eu-west-1.amazonaws.com/tee-black-front.png", "created_at": "2025-09-02T22:23:31.055Z", "deleted_at": null, "product_id": "prod_01K465NX26VFWW6C9Y3GJN3K6V", "unit_price": 10, "updated_at": "2025-09-02T22:23:31.055Z", "variant_id": "variant_01K465NX36QVW4VT9ZBR1WEYPA", "adjustments": [], "is_giftcard": false, "variant_sku": "SHIRT-M-BLACK", "product_type": null, "raw_subtotal": {"value": "10", "precision": 20}, "product_title": "Medusa T-Shirt", "raw_tax_total": {"value": "0", "precision": 20}, "variant_title": "M / Black", "discount_total": 0, "original_total": 10, "product_handle": "t-shirt", "raw_unit_price": {"value": "10", "precision": 20}, "is_custom_price": false, "is_discountable": true, "product_type_id": null, "variant_barcode": null, "is_tax_inclusive": false, "product_subtitle": null, "discount_subtotal": 0, "requires_shipping": true, "discount_tax_total": 0, "original_tax_total": 0, "product_collection": null, "raw_discount_total": {"value": "0", "precision": 20}, "raw_original_total": {"value": "10", "precision": 20}, "product_description": "Reimagine the feeling of a classic T-shirt. With our cotton T-shirts, everyday essentials no longer have to be ordinary.", "compare_at_unit_price": null, "raw_discount_subtotal": {"value": "0", "precision": 20}, "variant_option_values": null, "raw_discount_tax_total": {"value": "0", "precision": 20}, "raw_original_tax_total": {"value": "0", "precision": 20}, "raw_compare_at_unit_price": null}], "total": 20, "region": {"id": "reg_01K465NWZBB589QBS334WRK4PF", "name": "Europe", "metadata": null, "created_at": "2025-09-02T21:35:11.341Z", "deleted_at": null, "updated_at": "2025-09-02T21:35:11.341Z", "currency_code": "eur", "automatic_taxes": true}, "customer": {"id": "cus_01K46A0ZPRWKCSMQAW51DY0W8R", "email": "mk@mk.com", "phone": null, "groups": [], "metadata": null, "last_name": null, "created_at": "2025-09-02T22:51:08.888Z", "created_by": null, "deleted_at": null, "first_name": null, "updated_at": "2025-09-02T22:51:08.888Z", "has_account": false, "company_name": null}, "metadata": null, "subtotal": 20, "region_id": "reg_01K465NWZBB589QBS334WRK4PF", "item_total": 10, "promotions": [], "customer_id": "cus_01K46A0ZPRWKCSMQAW51DY0W8R", "completed_at": null, "currency_code": "eur", "item_subtotal": 10, "sales_channel_id": "sc_01K465NVAAFMSJ0RGP5VCKEPVH", "shipping_address": {"id": "caaddr_01K46A0ZRNPRJP2YKVVCX2RH5W", "city": "varanasi", "phone": "", "company": "", "metadata": null, "province": "up", "address_1": "test", "address_2": "", "last_name": "test", "created_at": "2025-09-02T22:51:08.950Z", "deleted_at": null, "first_name": "test", "updated_at": "2025-09-02T22:51:08.950Z", "customer_id": null, "postal_code": "221002", "country_code": "it"}, "shipping_methods": [{"id": "casm_01K46A12WMTEF0WW2GPAESHJ3N", "data": {}, "name": "Standard Shipping", "total": 10, "amount": 10, "cart_id": "cart_01K466AXHFNSF95BC7REXFZ8B0", "metadata": null, "subtotal": 10, "raw_total": {"value": "10", "precision": 20}, "tax_lines": [], "tax_total": 0, "created_at": "2025-09-02T22:51:12.148Z", "deleted_at": null, "raw_amount": {"value": "10", "precision": 20}, "updated_at": "2025-09-02T22:51:12.148Z", "adjustments": [], "description": null, "raw_subtotal": {"value": "10", "precision": 20}, "raw_tax_total": {"value": "0", "precision": 20}, "discount_total": 0, "original_total": 10, "shipping_option": {"id": "so_01K465NX0W8FHES8P37CAFHZS3", "shipping_option_type_id": "sotype_01K465NX0WGE47H7NC6TPMQ1VT"}, "is_tax_inclusive": false, "discount_subtotal": 0, "discount_tax_total": 0, "original_tax_total": 0, "raw_discount_total": {"value": "0", "precision": 20}, "raw_original_total": {"value": "10", "precision": 20}, "shipping_option_id": "so_01K465NX0W8FHES8P37CAFHZS3", "raw_discount_subtotal": {"value": "0", "precision": 20}, "raw_discount_tax_total": {"value": "0", "precision": 20}, "raw_original_tax_total": {"value": "0", "precision": 20}}], "shipping_subtotal": 10}, "items": [], "shipping_methods": [{"id": "casm_01K46A12WMTEF0WW2GPAESHJ3N", "data": {}, "name": "Standard Shipping", "amount": 10, "cart_id": "cart_01K466AXHFNSF95BC7REXFZ8B0", "metadata": null, "tax_lines": [], "created_at": "2025-09-02T22:51:12.148Z", "deleted_at": null, "raw_amount": {"value": "10", "precision": 20}, "updated_at": "2025-09-02T22:51:12.148Z", "adjustments": [], "description": null, "is_tax_inclusive": false, "shipping_option_id": "so_01K465NX0W8FHES8P37CAFHZS3"}]}, "_eventsCount": 0, "transactionId": "upsert-tax-lines-as-step-refresh-cart-items-as-step-auto-01K46A12RDRJXRB1Y1TVQRHRSN"}}}}, "get-setPricingContext-result": {"__type": "Symbol(WorkflowWorkflowData)", "output": {"__type": "Symbol(WorkflowStepResponse)"}}, "update-cart-promotions-as-step": {"__type": "Symbol(WorkflowWorkflowData)", "output": {"__type": "Symbol(WorkflowStepResponse)", "compensateInput": {"errors": [], "thrownError": null, "transaction": {"flow": {"runId": "01K46A12RF3RVEMTWBR7A89T82", "state": "done", "steps": {"_root": {"id": "_root", "next": ["_root.use-remote-query"]}, "_root.use-remote-query": {"id": "_root.use-remote-query", "next": ["_root.use-remote-query.validate"], "uuid": "01K469C7MZRTB0J3E7K3J0NKVN", "depth": 1, "invoke": {"state": "done", "status": "ok"}, "attempts": 1, "failures": 0, "startedAt": 1756853472440, "compensate": {"state": "dormant", "status": "idle"}, "definition": {"uuid": "01K469C7MZRTB0J3E7K3J0NKVN", "action": "use-remote-query", "noCompensation": true}, "stepFailed": false, "lastAttempt": 1756853472440, "saveResponse": true}, "_root.use-remote-query.validate": {"id": "_root.use-remote-query.validate", "next": ["_root.use-remote-query.validate.get-promotion-codes-to-apply"], "uuid": "01K469C7MZZ7DZ9NJTQXHXQBKM", "depth": 2, "invoke": {"state": "done", "status": "ok"}, "attempts": 1, "failures": 0, "startedAt": 1756853472463, "compensate": {"state": "dormant", "status": "idle"}, "definition": {"uuid": "01K469C7MZZ7DZ9NJTQXHXQBKM", "action": "validate", "noCompensation": false}, "stepFailed": false, "lastAttempt": 1756853472463, "saveResponse": true}, "_root.use-remote-query.validate.get-promotion-codes-to-apply": {"id": "_root.use-remote-query.validate.get-promotion-codes-to-apply", "next": ["_root.use-remote-query.validate.get-promotion-codes-to-apply.get-actions-to-compute-from-promotions"], "uuid": "01K469C7MZZEZVY9PFRV35WWVP", "depth": 3, "invoke": {"state": "done", "status": "ok"}, "attempts": 1, "failures": 0, "startedAt": 1756853472474, "compensate": {"state": "dormant", "status": "idle"}, "definition": {"uuid": "01K469C7MZZEZVY9PFRV35WWVP", "action": "get-promotion-codes-to-apply", "noCompensation": true}, "stepFailed": false, "lastAttempt": 1756853472474, "saveResponse": true}, "_root.use-remote-query.validate.get-promotion-codes-to-apply.get-actions-to-compute-from-promotions": {"id": "_root.use-remote-query.validate.get-promotion-codes-to-apply.get-actions-to-compute-from-promotions", "next": ["_root.use-remote-query.validate.get-promotion-codes-to-apply.get-actions-to-compute-from-promotions.prepare-adjustments-from-promotion-actions"], "uuid": "01K469C7MZ230XVA7CPQMNBBZK", "depth": 4, "invoke": {"state": "done", "status": "ok"}, "attempts": 1, "failures": 0, "startedAt": 1756853472484, "compensate": {"state": "dormant", "status": "idle"}, "definition": {"uuid": "01K469C7MZ230XVA7CPQMNBBZK", "action": "get-actions-to-compute-from-promotions", "noCompensation": true}, "stepFailed": false, "lastAttempt": 1756853472484, "saveResponse": true}, "_root.use-remote-query.validate.get-promotion-codes-to-apply.get-actions-to-compute-from-promotions.prepare-adjustments-from-promotion-actions": {"id": "_root.use-remote-query.validate.get-promotion-codes-to-apply.get-actions-to-compute-from-promotions.prepare-adjustments-from-promotion-actions", "next": ["_root.use-remote-query.validate.get-promotion-codes-to-apply.get-actions-to-compute-from-promotions.prepare-adjustments-from-promotion-actions.remove-line-item-adjustments", "_root.use-remote-query.validate.get-promotion-codes-to-apply.get-actions-to-compute-from-promotions.prepare-adjustments-from-promotion-actions.remove-shipping-method-adjustments", "_root.use-remote-query.validate.get-promotion-codes-to-apply.get-actions-to-compute-from-promotions.prepare-adjustments-from-promotion-actions.create-line-item-adjustments", "_root.use-remote-query.validate.get-promotion-codes-to-apply.get-actions-to-compute-from-promotions.prepare-adjustments-from-promotion-actions.create-shipping-method-adjustments", "_root.use-remote-query.validate.get-promotion-codes-to-apply.get-actions-to-compute-from-promotions.prepare-adjustments-from-promotion-actions.update-cart-promotions"], "uuid": "01K469C7MZP1FZ49MXK5KS5WE8", "depth": 5, "invoke": {"state": "done", "status": "ok"}, "attempts": 1, "failures": 0, "startedAt": 1756853472505, "compensate": {"state": "dormant", "status": "idle"}, "definition": {"uuid": "01K469C7MZP1FZ49MXK5KS5WE8", "action": "prepare-adjustments-from-promotion-actions", "noCompensation": true}, "stepFailed": false, "lastAttempt": 1756853472505, "saveResponse": true}, "_root.use-remote-query.validate.get-promotion-codes-to-apply.get-actions-to-compute-from-promotions.prepare-adjustments-from-promotion-actions.update-cart-promotions": {"id": "_root.use-remote-query.validate.get-promotion-codes-to-apply.get-actions-to-compute-from-promotions.prepare-adjustments-from-promotion-actions.update-cart-promotions", "next": [], "uuid": "01K469C7MZJGSJ03P98Z1WX96N", "depth": 6, "invoke": {"state": "done", "status": "ok"}, "attempts": 1, "failures": 0, "startedAt": 1756853472517, "compensate": {"state": "dormant", "status": "idle"}, "definition": {"uuid": "01K469C7MZJGSJ03P98Z1WX96N", "action": "update-cart-promotions", "noCompensation": false}, "stepFailed": false, "lastAttempt": 1756853472517, "saveResponse": true}, "_root.use-remote-query.validate.get-promotion-codes-to-apply.get-actions-to-compute-from-promotions.prepare-adjustments-from-promotion-actions.create-line-item-adjustments": {"id": "_root.use-remote-query.validate.get-promotion-codes-to-apply.get-actions-to-compute-from-promotions.prepare-adjustments-from-promotion-actions.create-line-item-adjustments", "next": [], "uuid": "01K469C7MZXZCWKF2H3VYG92D9", "depth": 6, "invoke": {"state": "done", "status": "ok"}, "attempts": 1, "failures": 0, "startedAt": 1756853472517, "compensate": {"state": "dormant", "status": "idle"}, "definition": {"uuid": "01K469C7MZXZCWKF2H3VYG92D9", "action": "create-line-item-adjustments", "noCompensation": false}, "stepFailed": false, "lastAttempt": 1756853472517, "saveResponse": true}, "_root.use-remote-query.validate.get-promotion-codes-to-apply.get-actions-to-compute-from-promotions.prepare-adjustments-from-promotion-actions.remove-line-item-adjustments": {"id": "_root.use-remote-query.validate.get-promotion-codes-to-apply.get-actions-to-compute-from-promotions.prepare-adjustments-from-promotion-actions.remove-line-item-adjustments", "next": [], "uuid": "01K469C7MZVTP07XXFPT7GTEAN", "depth": 6, "invoke": {"state": "done", "status": "ok"}, "attempts": 1, "failures": 0, "startedAt": 1756853472517, "compensate": {"state": "dormant", "status": "idle"}, "definition": {"uuid": "01K469C7MZVTP07XXFPT7GTEAN", "action": "remove-line-item-adjustments", "noCompensation": false}, "stepFailed": false, "lastAttempt": 1756853472517, "saveResponse": true}, "_root.use-remote-query.validate.get-promotion-codes-to-apply.get-actions-to-compute-from-promotions.prepare-adjustments-from-promotion-actions.create-shipping-method-adjustments": {"id": "_root.use-remote-query.validate.get-promotion-codes-to-apply.get-actions-to-compute-from-promotions.prepare-adjustments-from-promotion-actions.create-shipping-method-adjustments", "next": [], "uuid": "01K469C7MZBETCGP1B1XFG2GAH", "depth": 6, "invoke": {"state": "done", "status": "ok"}, "attempts": 1, "failures": 0, "startedAt": 1756853472517, "compensate": {"state": "dormant", "status": "idle"}, "definition": {"uuid": "01K469C7MZBETCGP1B1XFG2GAH", "action": "create-shipping-method-adjustments", "noCompensation": false}, "stepFailed": false, "lastAttempt": 1756853472517, "saveResponse": true}, "_root.use-remote-query.validate.get-promotion-codes-to-apply.get-actions-to-compute-from-promotions.prepare-adjustments-from-promotion-actions.remove-shipping-method-adjustments": {"id": "_root.use-remote-query.validate.get-promotion-codes-to-apply.get-actions-to-compute-from-promotions.prepare-adjustments-from-promotion-actions.remove-shipping-method-adjustments", "next": [], "uuid": "01K469C7MZH7W9A6EVXK2SEVDY", "depth": 6, "invoke": {"state": "done", "status": "ok"}, "attempts": 1, "failures": 0, "startedAt": 1756853472517, "compensate": {"state": "dormant", "status": "idle"}, "definition": {"uuid": "01K469C7MZH7W9A6EVXK2SEVDY", "action": "remove-shipping-method-adjustments", "noCompensation": false}, "stepFailed": false, "lastAttempt": 1756853472517, "saveResponse": true}}, "modelId": "update-cart-promotions", "options": {"name": "update-cart-promotions", "store": true, "idempotent": true}, "metadata": {"sourcePath": "/Users/mukul/Documents/GitHub/pharmint-marketplace/backend/node_modules/@medusajs/core-flows/dist/cart/workflows/update-cart-promotions.js", "eventGroupId": "01K46A12RD5DTAJW3P0DEHRKZB", "preventReleaseEvents": true, "parentStepIdempotencyKey": "refresh-cart-items:refresh-cart-items-as-step-auto-01K46A12RDRJXRB1Y1TVQRHRSN:update-cart-promotions-as-step:invoke"}, "startedAt": 1756853472437, "definition": {"next": {"next": {"next": {"next": {"next": [{"uuid": "01K469C7MZVTP07XXFPT7GTEAN", "action": "remove-line-item-adjustments", "noCompensation": false}, {"uuid": "01K469C7MZH7W9A6EVXK2SEVDY", "action": "remove-shipping-method-adjustments", "noCompensation": false}, {"uuid": "01K469C7MZXZCWKF2H3VYG92D9", "action": "create-line-item-adjustments", "noCompensation": false}, {"uuid": "01K469C7MZBETCGP1B1XFG2GAH", "action": "create-shipping-method-adjustments", "noCompensation": false}, {"uuid": "01K469C7MZJGSJ03P98Z1WX96N", "action": "update-cart-promotions", "noCompensation": false}], "uuid": "01K469C7MZP1FZ49MXK5KS5WE8", "action": "prepare-adjustments-from-promotion-actions", "noCompensation": true}, "uuid": "01K469C7MZ230XVA7CPQMNBBZK", "action": "get-actions-to-compute-from-promotions", "noCompensation": true}, "uuid": "01K469C7MZZEZVY9PFRV35WWVP", "action": "get-promotion-codes-to-apply", "noCompensation": true}, "uuid": "01K469C7MZZ7DZ9NJTQXHXQBKM", "action": "validate", "noCompensation": false}, "uuid": "01K469C7MZRTB0J3E7K3J0NKVN", "action": "use-remote-query", "noCompensation": true}, "timedOutAt": null, "hasAsyncSteps": false, "transactionId": "update-cart-promotions-as-step-refresh-cart-items-as-step-auto-01K46A12RDRJXRB1Y1TVQRHRSN", "hasFailedSteps": false, "hasSkippedSteps": false, "hasWaitingSteps": false, "hasRevertedSteps": false, "hasSkippedOnFailureSteps": false}, "runId": "01K46A12RF3RVEMTWBR7A89T82", "errors": [], "_events": {}, "context": {"invoke": {"validate": {"__type": "Symbol(WorkflowWorkflowData)", "output": {"__type": "Symbol(WorkflowStepResponse)"}}, "use-remote-query": {"__type": "Symbol(WorkflowWorkflowData)", "output": {"__type": "Symbol(WorkflowStepResponse)", "output": {"id": "cart_01K466AXHFNSF95BC7REXFZ8B0", "items": [{"id": "cali_01K468ECQFE8SQKS9467B5AD66", "title": "Medusa T-Shirt", "total": 10, "cart_id": "cart_01K466AXHFNSF95BC7REXFZ8B0", "product": {"id": "prod_01K465NX26VFWW6C9Y3GJN3K6V", "tags": [], "type_id": null, "categories": [], "is_giftcard": false, "collection_id": null}, "variant": {"id": "variant_01K465NX36QVW4VT9ZBR1WEYPA", "width": null, "height": null, "length": null, "weight": null, "product": {"id": "prod_01K465NX26VFWW6C9Y3GJN3K6V"}, "material": null, "product_id": "prod_01K465NX26VFWW6C9Y3GJN3K6V"}, "metadata": {}, "quantity": 1, "subtitle": "M / Black", "subtotal": 10, "raw_total": {"value": "10", "precision": 20}, "tax_lines": [], "tax_total": 0, "thumbnail": "https://medusa-public-images.s3.eu-west-1.amazonaws.com/tee-black-front.png", "created_at": "2025-09-02T22:23:31.055Z", "deleted_at": null, "product_id": "prod_01K465NX26VFWW6C9Y3GJN3K6V", "unit_price": 10, "updated_at": "2025-09-02T22:23:31.055Z", "variant_id": "variant_01K465NX36QVW4VT9ZBR1WEYPA", "adjustments": [], "is_giftcard": false, "variant_sku": "SHIRT-M-BLACK", "product_type": null, "raw_subtotal": {"value": "10", "precision": 20}, "product_title": "Medusa T-Shirt", "raw_tax_total": {"value": "0", "precision": 20}, "variant_title": "M / Black", "discount_total": 0, "original_total": 10, "product_handle": "t-shirt", "raw_unit_price": {"value": "10", "precision": 20}, "is_custom_price": false, "is_discountable": true, "product_type_id": null, "variant_barcode": null, "is_tax_inclusive": false, "product_subtitle": null, "discount_subtotal": 0, "requires_shipping": true, "discount_tax_total": 0, "original_tax_total": 0, "product_collection": null, "raw_discount_total": {"value": "0", "precision": 20}, "raw_original_total": {"value": "10", "precision": 20}, "product_description": "Reimagine the feeling of a classic T-shirt. With our cotton T-shirts, everyday essentials no longer have to be ordinary.", "compare_at_unit_price": null, "raw_discount_subtotal": {"value": "0", "precision": 20}, "variant_option_values": null, "raw_discount_tax_total": {"value": "0", "precision": 20}, "raw_original_tax_total": {"value": "0", "precision": 20}, "raw_compare_at_unit_price": null}], "total": 20, "region": {"id": "reg_01K465NWZBB589QBS334WRK4PF", "name": "Europe", "metadata": null, "created_at": "2025-09-02T21:35:11.341Z", "deleted_at": null, "updated_at": "2025-09-02T21:35:11.341Z", "currency_code": "eur", "automatic_taxes": true}, "customer": {"id": "cus_01K46A0ZPRWKCSMQAW51DY0W8R", "email": "mk@mk.com", "phone": null, "groups": [], "metadata": null, "last_name": null, "created_at": "2025-09-02T22:51:08.888Z", "created_by": null, "deleted_at": null, "first_name": null, "updated_at": "2025-09-02T22:51:08.888Z", "has_account": false, "company_name": null}, "metadata": null, "subtotal": 20, "region_id": "reg_01K465NWZBB589QBS334WRK4PF", "item_total": 10, "promotions": [], "customer_id": "cus_01K46A0ZPRWKCSMQAW51DY0W8R", "completed_at": null, "currency_code": "eur", "item_subtotal": 10, "sales_channel_id": "sc_01K465NVAAFMSJ0RGP5VCKEPVH", "shipping_address": {"id": "caaddr_01K46A0ZRNPRJP2YKVVCX2RH5W", "city": "varanasi", "phone": "", "company": "", "metadata": null, "province": "up", "address_1": "test", "address_2": "", "last_name": "test", "created_at": "2025-09-02T22:51:08.950Z", "deleted_at": null, "first_name": "test", "updated_at": "2025-09-02T22:51:08.950Z", "customer_id": null, "postal_code": "221002", "country_code": "it"}, "shipping_methods": [{"id": "casm_01K46A12WMTEF0WW2GPAESHJ3N", "data": {}, "name": "Standard Shipping", "total": 10, "amount": 10, "cart_id": "cart_01K466AXHFNSF95BC7REXFZ8B0", "metadata": null, "subtotal": 10, "raw_total": {"value": "10", "precision": 20}, "tax_lines": [], "tax_total": 0, "created_at": "2025-09-02T22:51:12.148Z", "deleted_at": null, "raw_amount": {"value": "10", "precision": 20}, "updated_at": "2025-09-02T22:51:12.148Z", "adjustments": [], "description": null, "raw_subtotal": {"value": "10", "precision": 20}, "raw_tax_total": {"value": "0", "precision": 20}, "discount_total": 0, "original_total": 10, "shipping_option": {"id": "so_01K465NX0W8FHES8P37CAFHZS3", "shipping_option_type_id": "sotype_01K465NX0WGE47H7NC6TPMQ1VT"}, "is_tax_inclusive": false, "discount_subtotal": 0, "discount_tax_total": 0, "original_tax_total": 0, "raw_discount_total": {"value": "0", "precision": 20}, "raw_original_total": {"value": "10", "precision": 20}, "shipping_option_id": "so_01K465NX0W8FHES8P37CAFHZS3", "raw_discount_subtotal": {"value": "0", "precision": 20}, "raw_discount_tax_total": {"value": "0", "precision": 20}, "raw_original_tax_total": {"value": "0", "precision": 20}}], "shipping_subtotal": 10}, "compensateInput": {"id": "cart_01K466AXHFNSF95BC7REXFZ8B0", "items": [{"id": "cali_01K468ECQFE8SQKS9467B5AD66", "title": "Medusa T-Shirt", "total": 10, "cart_id": "cart_01K466AXHFNSF95BC7REXFZ8B0", "product": {"id": "prod_01K465NX26VFWW6C9Y3GJN3K6V", "tags": [], "type_id": null, "categories": [], "is_giftcard": false, "collection_id": null}, "variant": {"id": "variant_01K465NX36QVW4VT9ZBR1WEYPA", "width": null, "height": null, "length": null, "weight": null, "product": {"id": "prod_01K465NX26VFWW6C9Y3GJN3K6V"}, "material": null, "product_id": "prod_01K465NX26VFWW6C9Y3GJN3K6V"}, "metadata": {}, "quantity": 1, "subtitle": "M / Black", "subtotal": 10, "raw_total": {"value": "10", "precision": 20}, "tax_lines": [], "tax_total": 0, "thumbnail": "https://medusa-public-images.s3.eu-west-1.amazonaws.com/tee-black-front.png", "created_at": "2025-09-02T22:23:31.055Z", "deleted_at": null, "product_id": "prod_01K465NX26VFWW6C9Y3GJN3K6V", "unit_price": 10, "updated_at": "2025-09-02T22:23:31.055Z", "variant_id": "variant_01K465NX36QVW4VT9ZBR1WEYPA", "adjustments": [], "is_giftcard": false, "variant_sku": "SHIRT-M-BLACK", "product_type": null, "raw_subtotal": {"value": "10", "precision": 20}, "product_title": "Medusa T-Shirt", "raw_tax_total": {"value": "0", "precision": 20}, "variant_title": "M / Black", "discount_total": 0, "original_total": 10, "product_handle": "t-shirt", "raw_unit_price": {"value": "10", "precision": 20}, "is_custom_price": false, "is_discountable": true, "product_type_id": null, "variant_barcode": null, "is_tax_inclusive": false, "product_subtitle": null, "discount_subtotal": 0, "requires_shipping": true, "discount_tax_total": 0, "original_tax_total": 0, "product_collection": null, "raw_discount_total": {"value": "0", "precision": 20}, "raw_original_total": {"value": "10", "precision": 20}, "product_description": "Reimagine the feeling of a classic T-shirt. With our cotton T-shirts, everyday essentials no longer have to be ordinary.", "compare_at_unit_price": null, "raw_discount_subtotal": {"value": "0", "precision": 20}, "variant_option_values": null, "raw_discount_tax_total": {"value": "0", "precision": 20}, "raw_original_tax_total": {"value": "0", "precision": 20}, "raw_compare_at_unit_price": null}], "total": 20, "region": {"id": "reg_01K465NWZBB589QBS334WRK4PF", "name": "Europe", "metadata": null, "created_at": "2025-09-02T21:35:11.341Z", "deleted_at": null, "updated_at": "2025-09-02T21:35:11.341Z", "currency_code": "eur", "automatic_taxes": true}, "customer": {"id": "cus_01K46A0ZPRWKCSMQAW51DY0W8R", "email": "mk@mk.com", "phone": null, "groups": [], "metadata": null, "last_name": null, "created_at": "2025-09-02T22:51:08.888Z", "created_by": null, "deleted_at": null, "first_name": null, "updated_at": "2025-09-02T22:51:08.888Z", "has_account": false, "company_name": null}, "metadata": null, "subtotal": 20, "region_id": "reg_01K465NWZBB589QBS334WRK4PF", "item_total": 10, "promotions": [], "customer_id": "cus_01K46A0ZPRWKCSMQAW51DY0W8R", "completed_at": null, "currency_code": "eur", "item_subtotal": 10, "sales_channel_id": "sc_01K465NVAAFMSJ0RGP5VCKEPVH", "shipping_address": {"id": "caaddr_01K46A0ZRNPRJP2YKVVCX2RH5W", "city": "varanasi", "phone": "", "company": "", "metadata": null, "province": "up", "address_1": "test", "address_2": "", "last_name": "test", "created_at": "2025-09-02T22:51:08.950Z", "deleted_at": null, "first_name": "test", "updated_at": "2025-09-02T22:51:08.950Z", "customer_id": null, "postal_code": "221002", "country_code": "it"}, "shipping_methods": [{"id": "casm_01K46A12WMTEF0WW2GPAESHJ3N", "data": {}, "name": "Standard Shipping", "total": 10, "amount": 10, "cart_id": "cart_01K466AXHFNSF95BC7REXFZ8B0", "metadata": null, "subtotal": 10, "raw_total": {"value": "10", "precision": 20}, "tax_lines": [], "tax_total": 0, "created_at": "2025-09-02T22:51:12.148Z", "deleted_at": null, "raw_amount": {"value": "10", "precision": 20}, "updated_at": "2025-09-02T22:51:12.148Z", "adjustments": [], "description": null, "raw_subtotal": {"value": "10", "precision": 20}, "raw_tax_total": {"value": "0", "precision": 20}, "discount_total": 0, "original_total": 10, "shipping_option": {"id": "so_01K465NX0W8FHES8P37CAFHZS3", "shipping_option_type_id": "sotype_01K465NX0WGE47H7NC6TPMQ1VT"}, "is_tax_inclusive": false, "discount_subtotal": 0, "discount_tax_total": 0, "original_tax_total": 0, "raw_discount_total": {"value": "0", "precision": 20}, "raw_original_total": {"value": "10", "precision": 20}, "shipping_option_id": "so_01K465NX0W8FHES8P37CAFHZS3", "raw_discount_subtotal": {"value": "0", "precision": 20}, "raw_discount_tax_total": {"value": "0", "precision": 20}, "raw_original_tax_total": {"value": "0", "precision": 20}}], "shipping_subtotal": 10}}}, "update-cart-promotions": {"__type": "Symbol(WorkflowWorkflowData)", "output": {"__type": "Symbol(WorkflowStepResponse)", "output": null, "compensateInput": {"createdLinkIds": [], "dismissedLinks": []}}}, "create-line-item-adjustments": {"__type": "Symbol(WorkflowWorkflowData)", "output": {"__type": "Symbol(WorkflowStepResponse)", "output": [], "compensateInput": []}}, "get-promotion-codes-to-apply": {"__type": "Symbol(WorkflowWorkflowData)", "output": {"__type": "Symbol(WorkflowStepResponse)", "output": [], "compensateInput": []}}, "remove-line-item-adjustments": {"__type": "Symbol(WorkflowWorkflowData)", "output": {"__type": "Symbol(WorkflowStepResponse)", "compensateInput": []}}, "create-shipping-method-adjustments": {"__type": "Symbol(WorkflowWorkflowData)", "output": {"__type": "Symbol(WorkflowStepResponse)", "compensateInput": []}}, "remove-shipping-method-adjustments": {"__type": "Symbol(WorkflowWorkflowData)", "output": {"__type": "Symbol(WorkflowStepResponse)", "compensateInput": []}}, "get-actions-to-compute-from-promotions": {"__type": "Symbol(WorkflowWorkflowData)", "output": {"__type": "Symbol(WorkflowStepResponse)", "output": [], "compensateInput": []}}, "prepare-adjustments-from-promotion-actions": {"__type": "Symbol(WorkflowWorkflowData)", "output": {"__type": "Symbol(WorkflowStepResponse)", "output": {"computedPromotionCodes": [], "lineItemAdjustmentsToCreate": [], "lineItemAdjustmentIdsToRemove": [], "shippingMethodAdjustmentsToCreate": [], "shippingMethodAdjustmentIdsToRemove": []}, "compensateInput": {"computedPromotionCodes": [], "lineItemAdjustmentsToCreate": [], "lineItemAdjustmentIdsToRemove": [], "shippingMethodAdjustmentsToCreate": [], "shippingMethodAdjustmentIdsToRemove": []}}}}, "payload": {"action": "replace", "cart_id": "cart_01K466AXHFNSF95BC7REXFZ8B0", "promo_codes": []}, "compensate": {}}, "modelId": "update-cart-promotions", "payload": {"action": "replace", "cart_id": "cart_01K466AXHFNSF95BC7REXFZ8B0", "promo_codes": []}, "_eventsCount": 0, "transactionId": "update-cart-promotions-as-step-refresh-cart-items-as-step-auto-01K46A12RDRJXRB1Y1TVQRHRSN"}}}}, "beforeRefreshingPaymentCollection": {"__type": "Symbol(WorkflowWorkflowData)", "output": {"__type": "Symbol(WorkflowStepResponse)"}}, "refresh-cart-shipping-methods-as-step": {"__type": "Symbol(WorkflowWorkflowData)", "output": {"__type": "Symbol(WorkflowStepResponse)", "compensateInput": {"errors": [], "thrownError": null, "transaction": {"flow": {"runId": "01K46A12RF3RVEMTWBR7A89T82", "state": "done", "steps": {"_root": {"id": "_root", "next": ["_root.get-cart"]}, "_root.get-cart": {"id": "_root.get-cart", "next": ["_root.get-cart.validate"], "uuid": "01K469C7MQCHMC23YZT1NTG73R", "depth": 1, "invoke": {"state": "skipped", "status": "ok"}, "attempts": 1, "failures": 0, "startedAt": 1756853472261, "compensate": {"state": "dormant", "status": "idle"}, "definition": {"uuid": "01K469C7MQCHMC23YZT1NTG73R", "async": false, "action": "get-cart", "noCompensation": true, "compensateAsync": false}, "stepFailed": false, "lastAttempt": 1756853472261, "saveResponse": true}, "_root.get-cart.validate": {"id": "_root.get-cart.validate", "next": ["_root.get-cart.validate.list-shipping-options-for-cart-with-pricing-as-step"], "uuid": "01K469C7MQMQBKT88Y31SGRCZV", "depth": 2, "invoke": {"state": "done", "status": "ok"}, "attempts": 1, "failures": 0, "startedAt": 1756853472267, "compensate": {"state": "dormant", "status": "idle"}, "definition": {"uuid": "01K469C7MQMQBKT88Y31SGRCZV", "action": "validate", "noCompensation": false}, "stepFailed": false, "lastAttempt": 1756853472267, "saveResponse": true}, "_root.get-cart.validate.list-shipping-options-for-cart-with-pricing-as-step": {"id": "_root.get-cart.validate.list-shipping-options-for-cart-with-pricing-as-step", "next": ["_root.get-cart.validate.list-shipping-options-for-cart-with-pricing-as-step.remove-shipping-method-to-cart-step", "_root.get-cart.validate.list-shipping-options-for-cart-with-pricing-as-step.update-shipping-methods-step"], "uuid": "01K469C7MQ9ZH8WP61QVYA9WGD", "depth": 3, "invoke": {"state": "done", "status": "ok"}, "attempts": 1, "failures": 0, "startedAt": 1756853472273, "compensate": {"state": "dormant", "status": "idle"}, "definition": {"name": "list-shipping-options-for-cart-with-pricing-as-step", "uuid": "01K469C7MQ9ZH8WP61QVYA9WGD", "async": false, "action": "list-shipping-options-for-cart-with-pricing-as-step", "nested": false, "noCompensation": false}, "stepFailed": false, "lastAttempt": 1756853472273, "saveResponse": true}, "_root.get-cart.validate.list-shipping-options-for-cart-with-pricing-as-step.update-shipping-methods-step": {"id": "_root.get-cart.validate.list-shipping-options-for-cart-with-pricing-as-step.update-shipping-methods-step", "next": [], "uuid": "01K469C7MQ2T7N5YP36F1GQ10Z", "depth": 4, "invoke": {"state": "done", "status": "ok"}, "attempts": 1, "failures": 0, "startedAt": 1756853472326, "compensate": {"state": "dormant", "status": "idle"}, "definition": {"uuid": "01K469C7MQ2T7N5YP36F1GQ10Z", "action": "update-shipping-methods-step", "noCompensation": false}, "stepFailed": false, "lastAttempt": 1756853472326, "saveResponse": true}, "_root.get-cart.validate.list-shipping-options-for-cart-with-pricing-as-step.remove-shipping-method-to-cart-step": {"id": "_root.get-cart.validate.list-shipping-options-for-cart-with-pricing-as-step.remove-shipping-method-to-cart-step", "next": [], "uuid": "01K469C7MQRZ9V334QTJ18V5ZX", "depth": 4, "invoke": {"state": "done", "status": "ok"}, "attempts": 1, "failures": 0, "startedAt": 1756853472326, "compensate": {"state": "dormant", "status": "idle"}, "definition": {"uuid": "01K469C7MQRZ9V334QTJ18V5ZX", "action": "remove-shipping-method-to-cart-step", "noCompensation": false}, "stepFailed": false, "lastAttempt": 1756853472326, "saveResponse": true}}, "modelId": "refresh-cart-shipping-methods", "options": {"name": "refresh-cart-shipping-methods", "store": true, "idempotent": true}, "metadata": {"sourcePath": "/Users/mukul/Documents/GitHub/pharmint-marketplace/backend/node_modules/@medusajs/core-flows/dist/cart/workflows/refresh-cart-shipping-methods.js", "eventGroupId": "01K46A12RD5DTAJW3P0DEHRKZB", "preventReleaseEvents": true, "parentStepIdempotencyKey": "refresh-cart-items:refresh-cart-items-as-step-auto-01K46A12RDRJXRB1Y1TVQRHRSN:refresh-cart-shipping-methods-as-step:invoke"}, "startedAt": 1756853472258, "definition": {"next": {"next": {"name": "list-shipping-options-for-cart-with-pricing-as-step", "next": [{"uuid": "01K469C7MQRZ9V334QTJ18V5ZX", "action": "remove-shipping-method-to-cart-step", "noCompensation": false}, {"uuid": "01K469C7MQ2T7N5YP36F1GQ10Z", "action": "update-shipping-methods-step", "noCompensation": false}], "uuid": "01K469C7MQ9ZH8WP61QVYA9WGD", "async": false, "action": "list-shipping-options-for-cart-with-pricing-as-step", "nested": false, "noCompensation": false}, "uuid": "01K469C7MQMQBKT88Y31SGRCZV", "action": "validate", "noCompensation": false}, "uuid": "01K469C7MQCHMC23YZT1NTG73R", "async": false, "action": "get-cart", "noCompensation": true, "compensateAsync": false}, "timedOutAt": null, "hasAsyncSteps": false, "transactionId": "refresh-cart-shipping-methods-as-step-refresh-cart-items-as-step-auto-01K46A12RDRJXRB1Y1TVQRHRSN", "hasFailedSteps": false, "hasSkippedSteps": true, "hasWaitingSteps": false, "hasRevertedSteps": false, "hasSkippedOnFailureSteps": false}, "runId": "01K46A12RF3RVEMTWBR7A89T82", "errors": [], "_events": {}, "context": {"invoke": {"validate": {"__type": "Symbol(WorkflowWorkflowData)", "output": {"__type": "Symbol(WorkflowStepResponse)"}}, "update-shipping-methods-step": {"__type": "Symbol(WorkflowWorkflowData)", "output": {"__type": "Symbol(WorkflowStepResponse)", "output": [{"id": "casm_01K46A12WMTEF0WW2GPAESHJ3N", "cart": {"id": "cart_01K466AXHFNSF95BC7REXFZ8B0"}, "data": {}, "name": "Standard Shipping", "amount": 10, "cart_id": "cart_01K466AXHFNSF95BC7REXFZ8B0", "metadata": null, "created_at": "2025-09-02T22:51:12.148Z", "deleted_at": null, "raw_amount": {"value": "10", "precision": 20}, "updated_at": "2025-09-02T22:51:12.148Z", "description": null, "is_tax_inclusive": false, "shipping_option_id": "so_01K465NX0W8FHES8P37CAFHZS3"}], "compensateInput": [{"id": "casm_01K46A12WMTEF0WW2GPAESHJ3N", "amount": 10, "raw_amount": {"value": "10", "precision": 20}, "is_tax_inclusive": false, "shipping_option_id": "so_01K465NX0W8FHES8P37CAFHZS3"}]}}, "remove-shipping-method-to-cart-step": {"__type": "Symbol(WorkflowWorkflowData)", "output": {"__type": "Symbol(WorkflowStepResponse)", "output": null, "compensateInput": []}}, "list-shipping-options-for-cart-with-pricing-as-step": {"__type": "Symbol(WorkflowWorkflowData)", "output": {"__type": "Symbol(WorkflowStepResponse)", "output": [{"id": "so_01K465NX0W8FHES8P37CAFHZS3", "data": null, "name": "Standard Shipping", "type": {"id": "sotype_01K465NX0WGE47H7NC6TPMQ1VT", "code": "standard", "label": "Standard", "description": "Ship in 2-3 days."}, "rules": [{"value": "true", "operator": "eq", "attribute": "enabled_in_store"}, {"value": "false", "operator": "eq", "attribute": "is_return"}], "amount": 10, "prices": [{"id": "price_01K465NX13YV0869BSEMPE88P6", "title": null, "amount": 10, "created_at": "2025-09-02T21:35:11.396Z", "deleted_at": null, "price_list": null, "raw_amount": {"value": "10", "precision": 20}, "updated_at": "2025-09-02T21:35:11.396Z", "price_rules": [], "rules_count": 0, "max_quantity": null, "min_quantity": null, "price_set_id": "pset_01K465NX13CASJ8S3MJ3RY8NN0", "currency_code": "eur", "price_list_id": null}, {"id": "price_01K465NX13NW3SRA7AEEZVFP07", "title": null, "amount": 10, "created_at": "2025-09-02T21:35:11.396Z", "deleted_at": null, "price_list": null, "raw_amount": {"value": "10", "precision": 20}, "updated_at": "2025-09-02T21:35:11.396Z", "price_rules": [{"id": "prule_01K465NX13952QNKKADD38EZ3D", "value": "reg_01K465NWZBB589QBS334WRK4PF", "operator": "eq", "price_id": "price_01K465NX13NW3SRA7AEEZVFP07", "priority": 0, "attribute": "region_id", "created_at": "2025-09-02T21:35:11.396Z", "deleted_at": null, "updated_at": "2025-09-02T21:35:11.396Z"}], "rules_count": 1, "max_quantity": null, "min_quantity": null, "price_set_id": "pset_01K465NX13CASJ8S3MJ3RY8NN0", "currency_code": "eur", "price_list_id": null}, {"id": "price_01K465NX135PCBC1E9Q2P5KJ36", "title": null, "amount": 10, "created_at": "2025-09-02T21:35:11.396Z", "deleted_at": null, "price_list": null, "raw_amount": {"value": "10", "precision": 20}, "updated_at": "2025-09-02T21:35:11.396Z", "price_rules": [], "rules_count": 0, "max_quantity": null, "min_quantity": null, "price_set_id": "pset_01K465NX13CASJ8S3MJ3RY8NN0", "currency_code": "usd", "price_list_id": null}], "provider": {"id": "manual_manual", "is_enabled": true}, "price_type": "flat", "provider_id": "manual_manual", "service_zone": {"id": "serzo_01K465NX0B8X83QPDS4ZNJX86S", "fulfillment_set": {"id": "fuset_01K465NX0BS3XBXW4G9VJ79T0Z", "type": "shipping", "location": {"id": "sloc_01K465NX02PRA37GR065XPNVC1", "address": {"id": "laddr_01K465NX02JG26E8Z5N4C83M68", "city": "Copenhagen", "phone": null, "company": null, "metadata": null, "province": null, "address_1": "", "address_2": null, "created_at": "2025-09-02T21:35:11.362Z", "deleted_at": null, "updated_at": "2025-09-02T21:35:11.362Z", "postal_code": null, "country_code": "DK"}}}, "fulfillment_set_id": "fuset_01K465NX0BS3XBXW4G9VJ79T0Z"}, "service_zone_id": "serzo_01K465NX0B8X83QPDS4ZNJX86S", "calculated_price": {"id": "pset_01K465NX13CASJ8S3MJ3RY8NN0", "currency_code": "eur", "original_price": {"id": "price_01K465NX13NW3SRA7AEEZVFP07", "max_quantity": null, "min_quantity": null, "price_list_id": null, "price_list_type": null}, "original_amount": 10, "calculated_price": {"id": "price_01K465NX13NW3SRA7AEEZVFP07", "max_quantity": null, "min_quantity": null, "price_list_id": null, "price_list_type": null}, "calculated_amount": 10, "raw_original_amount": {"value": "10", "precision": 20}, "raw_calculated_amount": {"value": "10", "precision": 20}, "is_original_price_price_list": false, "is_calculated_price_price_list": false, "is_original_price_tax_inclusive": false, "is_calculated_price_tax_inclusive": false}, "is_tax_inclusive": false, "shipping_profile_id": "sp_01K465NSMNCMB3KTQC20148JAW"}], "compensateInput": {"errors": [], "result": [{"id": "so_01K465NX0W8FHES8P37CAFHZS3", "data": null, "name": "Standard Shipping", "type": {"id": "sotype_01K465NX0WGE47H7NC6TPMQ1VT", "code": "standard", "label": "Standard", "description": "Ship in 2-3 days."}, "rules": [{"value": "true", "operator": "eq", "attribute": "enabled_in_store"}, {"value": "false", "operator": "eq", "attribute": "is_return"}], "amount": 10, "prices": [{"id": "price_01K465NX13YV0869BSEMPE88P6", "title": null, "amount": 10, "created_at": "2025-09-02T21:35:11.396Z", "deleted_at": null, "price_list": null, "raw_amount": {"value": "10", "precision": 20}, "updated_at": "2025-09-02T21:35:11.396Z", "price_rules": [], "rules_count": 0, "max_quantity": null, "min_quantity": null, "price_set_id": "pset_01K465NX13CASJ8S3MJ3RY8NN0", "currency_code": "eur", "price_list_id": null}, {"id": "price_01K465NX13NW3SRA7AEEZVFP07", "title": null, "amount": 10, "created_at": "2025-09-02T21:35:11.396Z", "deleted_at": null, "price_list": null, "raw_amount": {"value": "10", "precision": 20}, "updated_at": "2025-09-02T21:35:11.396Z", "price_rules": [{"id": "prule_01K465NX13952QNKKADD38EZ3D", "value": "reg_01K465NWZBB589QBS334WRK4PF", "operator": "eq", "price_id": "price_01K465NX13NW3SRA7AEEZVFP07", "priority": 0, "attribute": "region_id", "created_at": "2025-09-02T21:35:11.396Z", "deleted_at": null, "updated_at": "2025-09-02T21:35:11.396Z"}], "rules_count": 1, "max_quantity": null, "min_quantity": null, "price_set_id": "pset_01K465NX13CASJ8S3MJ3RY8NN0", "currency_code": "eur", "price_list_id": null}, {"id": "price_01K465NX135PCBC1E9Q2P5KJ36", "title": null, "amount": 10, "created_at": "2025-09-02T21:35:11.396Z", "deleted_at": null, "price_list": null, "raw_amount": {"value": "10", "precision": 20}, "updated_at": "2025-09-02T21:35:11.396Z", "price_rules": [], "rules_count": 0, "max_quantity": null, "min_quantity": null, "price_set_id": "pset_01K465NX13CASJ8S3MJ3RY8NN0", "currency_code": "usd", "price_list_id": null}], "provider": {"id": "manual_manual", "is_enabled": true}, "price_type": "flat", "provider_id": "manual_manual", "service_zone": {"id": "serzo_01K465NX0B8X83QPDS4ZNJX86S", "fulfillment_set": {"id": "fuset_01K465NX0BS3XBXW4G9VJ79T0Z", "type": "shipping", "location": {"id": "sloc_01K465NX02PRA37GR065XPNVC1", "address": {"id": "laddr_01K465NX02JG26E8Z5N4C83M68", "city": "Copenhagen", "phone": null, "company": null, "metadata": null, "province": null, "address_1": "", "address_2": null, "created_at": "2025-09-02T21:35:11.362Z", "deleted_at": null, "updated_at": "2025-09-02T21:35:11.362Z", "postal_code": null, "country_code": "DK"}}}, "fulfillment_set_id": "fuset_01K465NX0BS3XBXW4G9VJ79T0Z"}, "service_zone_id": "serzo_01K465NX0B8X83QPDS4ZNJX86S", "calculated_price": {"id": "pset_01K465NX13CASJ8S3MJ3RY8NN0", "currency_code": "eur", "original_price": {"id": "price_01K465NX13NW3SRA7AEEZVFP07", "max_quantity": null, "min_quantity": null, "price_list_id": null, "price_list_type": null}, "original_amount": 10, "calculated_price": {"id": "price_01K465NX13NW3SRA7AEEZVFP07", "max_quantity": null, "min_quantity": null, "price_list_id": null, "price_list_type": null}, "calculated_amount": 10, "raw_original_amount": {"value": "10", "precision": 20}, "raw_calculated_amount": {"value": "10", "precision": 20}, "is_original_price_price_list": false, "is_calculated_price_price_list": false, "is_original_price_tax_inclusive": false, "is_calculated_price_tax_inclusive": false}, "is_tax_inclusive": false, "shipping_profile_id": "sp_01K465NSMNCMB3KTQC20148JAW"}], "thrownError": null, "transaction": {"flow": {"runId": "01K46A12RF3RVEMTWBR7A89T82", "state": "done", "steps": {"_root": {"id": "_root", "next": ["_root.get-cart"]}, "_root.get-cart": {"id": "_root.get-cart", "next": ["_root.get-cart.validate-presence-of"], "uuid": "01K469C7MMC8FQ6EK6588BRY5K", "depth": 1, "invoke": {"state": "done", "status": "ok"}, "attempts": 1, "failures": 0, "startedAt": 1756853472276, "compensate": {"state": "dormant", "status": "idle"}, "definition": {"uuid": "01K469C7MMC8FQ6EK6588BRY5K", "async": false, "action": "get-cart", "noCompensation": true, "compensateAsync": false}, "stepFailed": false, "lastAttempt": 1756853472276, "saveResponse": true}, "_root.get-cart.validate-presence-of": {"id": "_root.get-cart.validate-presence-of", "next": ["_root.get-cart.validate-presence-of.sales_channels-fulfillment-query"], "uuid": "01K469C7MM5VN9033ECN4VGAHX", "depth": 2, "invoke": {"state": "done", "status": "ok"}, "attempts": 1, "failures": 0, "startedAt": 1756853472286, "compensate": {"state": "dormant", "status": "idle"}, "definition": {"uuid": "01K469C7MM5VN9033ECN4VGAHX", "action": "validate-presence-of", "noCompensation": true}, "stepFailed": false, "lastAttempt": 1756853472286, "saveResponse": true}, "_root.get-cart.validate-presence-of.sales_channels-fulfillment-query": {"id": "_root.get-cart.validate-presence-of.sales_channels-fulfillment-query", "next": ["_root.get-cart.validate-presence-of.sales_channels-fulfillment-query.shipping-options-price-type-query"], "uuid": "01K469C7MM4S9AS2P3PAAKJEP6", "depth": 3, "invoke": {"state": "done", "status": "ok"}, "attempts": 1, "failures": 0, "startedAt": 1756853472287, "compensate": {"state": "dormant", "status": "idle"}, "definition": {"uuid": "01K469C7MM4S9AS2P3PAAKJEP6", "async": false, "action": "sales_channels-fulfillment-query", "noCompensation": true, "compensateAsync": false}, "stepFailed": false, "lastAttempt": 1756853472287, "saveResponse": true}, "_root.get-cart.validate-presence-of.sales_channels-fulfillment-query.shipping-options-price-type-query": {"id": "_root.get-cart.validate-presence-of.sales_channels-fulfillment-query.shipping-options-price-type-query", "next": ["_root.get-cart.validate-presence-of.sales_channels-fulfillment-query.shipping-options-price-type-query.shipping-options-query-flat-rate", "_root.get-cart.validate-presence-of.sales_channels-fulfillment-query.shipping-options-price-type-query.shipping-options-query-calculated"], "uuid": "01K469C7MMX9DKGTWD36E117FX", "depth": 4, "invoke": {"state": "done", "status": "ok"}, "attempts": 1, "failures": 0, "startedAt": 1756853472291, "compensate": {"state": "dormant", "status": "idle"}, "definition": {"uuid": "01K469C7MMX9DKGTWD36E117FX", "async": false, "action": "shipping-options-price-type-query", "noCompensation": true, "compensateAsync": false}, "stepFailed": false, "lastAttempt": 1756853472291, "saveResponse": true}, "_root.get-cart.validate-presence-of.sales_channels-fulfillment-query.shipping-options-price-type-query.shipping-options-query-flat-rate": {"id": "_root.get-cart.validate-presence-of.sales_channels-fulfillment-query.shipping-options-price-type-query.shipping-options-query-flat-rate", "next": [], "uuid": "01K469C7MMM3Z966GCSASTBRBN", "depth": 5, "invoke": {"state": "done", "status": "ok"}, "attempts": 1, "failures": 0, "startedAt": 1756853472298, "compensate": {"state": "dormant", "status": "idle"}, "definition": {"uuid": "01K469C7MMM3Z966GCSASTBRBN", "async": false, "action": "shipping-options-query-flat-rate", "noCompensation": true, "compensateAsync": false}, "stepFailed": false, "lastAttempt": 1756853472298, "saveResponse": true}, "_root.get-cart.validate-presence-of.sales_channels-fulfillment-query.shipping-options-price-type-query.shipping-options-query-calculated": {"id": "_root.get-cart.validate-presence-of.sales_channels-fulfillment-query.shipping-options-price-type-query.shipping-options-query-calculated", "next": ["_root.get-cart.validate-presence-of.sales_channels-fulfillment-query.shipping-options-price-type-query.shipping-options-query-calculated.calculate-shipping-options-prices"], "uuid": "01K469C7MN76B2K37SE10V99X8", "depth": 5, "invoke": {"state": "done", "status": "ok"}, "attempts": 1, "failures": 0, "startedAt": 1756853472298, "compensate": {"state": "dormant", "status": "idle"}, "definition": {"uuid": "01K469C7MN76B2K37SE10V99X8", "async": false, "action": "shipping-options-query-calculated", "noCompensation": true, "compensateAsync": false}, "stepFailed": false, "lastAttempt": 1756853472298, "saveResponse": true}, "_root.get-cart.validate-presence-of.sales_channels-fulfillment-query.shipping-options-price-type-query.shipping-options-query-calculated.calculate-shipping-options-prices": {"id": "_root.get-cart.validate-presence-of.sales_channels-fulfillment-query.shipping-options-price-type-query.shipping-options-query-calculated.calculate-shipping-options-prices", "next": [], "uuid": "01K469C7MN9PREV9XC352WHDHS", "depth": 6, "invoke": {"state": "done", "status": "ok"}, "attempts": 1, "failures": 0, "startedAt": 1756853472318, "compensate": {"state": "dormant", "status": "idle"}, "definition": {"uuid": "01K469C7MN9PREV9XC352WHDHS", "action": "calculate-shipping-options-prices", "noCompensation": true}, "stepFailed": false, "lastAttempt": 1756853472318, "saveResponse": true}}, "modelId": "list-shipping-options-for-cart-with-pricing", "options": {}, "metadata": {"sourcePath": "/Users/mukul/Documents/GitHub/pharmint-marketplace/backend/node_modules/@medusajs/core-flows/dist/cart/workflows/list-shipping-options-for-cart-with-pricing.js", "eventGroupId": "01K46A12RD5DTAJW3P0DEHRKZB", "preventReleaseEvents": true, "parentStepIdempotencyKey": "refresh-cart-shipping-methods:refresh-cart-shipping-methods-as-step-refresh-cart-items-as-step-auto-01K46A12RDRJXRB1Y1TVQRHRSN:list-shipping-options-for-cart-with-pricing-as-step:invoke"}, "startedAt": 1756853472276, "definition": {"next": {"next": {"next": {"next": [{"uuid": "01K469C7MMM3Z966GCSASTBRBN", "async": false, "action": "shipping-options-query-flat-rate", "noCompensation": true, "compensateAsync": false}, {"next": {"uuid": "01K469C7MN9PREV9XC352WHDHS", "action": "calculate-shipping-options-prices", "noCompensation": true}, "uuid": "01K469C7MN76B2K37SE10V99X8", "async": false, "action": "shipping-options-query-calculated", "noCompensation": true, "compensateAsync": false}], "uuid": "01K469C7MMX9DKGTWD36E117FX", "async": false, "action": "shipping-options-price-type-query", "noCompensation": true, "compensateAsync": false}, "uuid": "01K469C7MM4S9AS2P3PAAKJEP6", "async": false, "action": "sales_channels-fulfillment-query", "noCompensation": true, "compensateAsync": false}, "uuid": "01K469C7MM5VN9033ECN4VGAHX", "action": "validate-presence-of", "noCompensation": true}, "uuid": "01K469C7MMC8FQ6EK6588BRY5K", "async": false, "action": "get-cart", "noCompensation": true, "compensateAsync": false}, "timedOutAt": null, "hasAsyncSteps": false, "transactionId": "list-shipping-options-for-cart-with-pricing-as-step-refresh-cart-shipping-methods-as-step-refresh-cart-items-as-step-auto-01K46A12RDRJXRB1Y1TVQRHRSN", "hasFailedSteps": false, "hasSkippedSteps": false, "hasWaitingSteps": false, "hasRevertedSteps": false, "hasSkippedOnFailureSteps": false}, "runId": "01K46A12RF3RVEMTWBR7A89T82", "errors": [], "_events": {}, "context": {"invoke": {"get-cart": {"__type": "Symbol(WorkflowWorkflowData)", "output": {"__type": "Symbol(WorkflowStepResponse)", "output": {"data": [{"id": "cart_01K466AXHFNSF95BC7REXFZ8B0", "items": [{"id": "cali_01K468ECQFE8SQKS9467B5AD66", "title": "Medusa T-Shirt", "total": 10, "cart_id": "cart_01K466AXHFNSF95BC7REXFZ8B0", "product": {"id": "prod_01K465NX26VFWW6C9Y3GJN3K6V", "tags": [], "categories": [], "collection_id": null}, "variant": {"id": "variant_01K465NX36QVW4VT9ZBR1WEYPA", "width": null, "height": null, "length": null, "weight": null, "product": {"id": "prod_01K465NX26VFWW6C9Y3GJN3K6V"}, "material": null, "product_id": "prod_01K465NX26VFWW6C9Y3GJN3K6V"}, "metadata": {}, "quantity": 1, "subtitle": "M / Black", "subtotal": 10, "raw_total": {"value": "10", "precision": 20}, "tax_lines": [], "tax_total": 0, "thumbnail": "https://medusa-public-images.s3.eu-west-1.amazonaws.com/tee-black-front.png", "created_at": "2025-09-02T22:23:31.055Z", "deleted_at": null, "product_id": "prod_01K465NX26VFWW6C9Y3GJN3K6V", "unit_price": 10, "updated_at": "2025-09-02T22:23:31.055Z", "variant_id": "variant_01K465NX36QVW4VT9ZBR1WEYPA", "adjustments": [], "is_giftcard": false, "variant_sku": "SHIRT-M-BLACK", "product_type": null, "raw_subtotal": {"value": "10", "precision": 20}, "product_title": "Medusa T-Shirt", "raw_tax_total": {"value": "0", "precision": 20}, "variant_title": "M / Black", "discount_total": 0, "original_total": 10, "product_handle": "t-shirt", "raw_unit_price": {"value": "10", "precision": 20}, "is_custom_price": false, "is_discountable": true, "product_type_id": null, "variant_barcode": null, "is_tax_inclusive": false, "product_subtitle": null, "discount_subtotal": 0, "requires_shipping": true, "discount_tax_total": 0, "original_tax_total": 0, "product_collection": null, "raw_discount_total": {"value": "0", "precision": 20}, "raw_original_total": {"value": "10", "precision": 20}, "product_description": "Reimagine the feeling of a classic T-shirt. With our cotton T-shirts, everyday essentials no longer have to be ordinary.", "compare_at_unit_price": null, "raw_discount_subtotal": {"value": "0", "precision": 20}, "variant_option_values": null, "raw_discount_tax_total": {"value": "0", "precision": 20}, "raw_original_tax_total": {"value": "0", "precision": 20}, "raw_compare_at_unit_price": null}], "total": 20, "region_id": "reg_01K465NWZBB589QBS334WRK4PF", "item_total": 10, "currency_code": "eur", "sales_channel_id": "sc_01K465NVAAFMSJ0RGP5VCKEPVH", "shipping_address": {"id": "caaddr_01K46A0ZRNPRJP2YKVVCX2RH5W", "city": "varanasi", "phone": "", "company": "", "metadata": null, "province": "up", "address_1": "test", "address_2": "", "last_name": "test", "created_at": "2025-09-02T22:51:08.950Z", "deleted_at": null, "first_name": "test", "updated_at": "2025-09-02T22:51:08.950Z", "customer_id": null, "postal_code": "221002", "country_code": "it"}}]}, "compensateInput": {"data": [{"id": "cart_01K466AXHFNSF95BC7REXFZ8B0", "items": [{"id": "cali_01K468ECQFE8SQKS9467B5AD66", "title": "Medusa T-Shirt", "total": 10, "cart_id": "cart_01K466AXHFNSF95BC7REXFZ8B0", "product": {"id": "prod_01K465NX26VFWW6C9Y3GJN3K6V", "tags": [], "categories": [], "collection_id": null}, "variant": {"id": "variant_01K465NX36QVW4VT9ZBR1WEYPA", "width": null, "height": null, "length": null, "weight": null, "product": {"id": "prod_01K465NX26VFWW6C9Y3GJN3K6V"}, "material": null, "product_id": "prod_01K465NX26VFWW6C9Y3GJN3K6V"}, "metadata": {}, "quantity": 1, "subtitle": "M / Black", "subtotal": 10, "raw_total": {"value": "10", "precision": 20}, "tax_lines": [], "tax_total": 0, "thumbnail": "https://medusa-public-images.s3.eu-west-1.amazonaws.com/tee-black-front.png", "created_at": "2025-09-02T22:23:31.055Z", "deleted_at": null, "product_id": "prod_01K465NX26VFWW6C9Y3GJN3K6V", "unit_price": 10, "updated_at": "2025-09-02T22:23:31.055Z", "variant_id": "variant_01K465NX36QVW4VT9ZBR1WEYPA", "adjustments": [], "is_giftcard": false, "variant_sku": "SHIRT-M-BLACK", "product_type": null, "raw_subtotal": {"value": "10", "precision": 20}, "product_title": "Medusa T-Shirt", "raw_tax_total": {"value": "0", "precision": 20}, "variant_title": "M / Black", "discount_total": 0, "original_total": 10, "product_handle": "t-shirt", "raw_unit_price": {"value": "10", "precision": 20}, "is_custom_price": false, "is_discountable": true, "product_type_id": null, "variant_barcode": null, "is_tax_inclusive": false, "product_subtitle": null, "discount_subtotal": 0, "requires_shipping": true, "discount_tax_total": 0, "original_tax_total": 0, "product_collection": null, "raw_discount_total": {"value": "0", "precision": 20}, "raw_original_total": {"value": "10", "precision": 20}, "product_description": "Reimagine the feeling of a classic T-shirt. With our cotton T-shirts, everyday essentials no longer have to be ordinary.", "compare_at_unit_price": null, "raw_discount_subtotal": {"value": "0", "precision": 20}, "variant_option_values": null, "raw_discount_tax_total": {"value": "0", "precision": 20}, "raw_original_tax_total": {"value": "0", "precision": 20}, "raw_compare_at_unit_price": null}], "total": 20, "region_id": "reg_01K465NWZBB589QBS334WRK4PF", "item_total": 10, "currency_code": "eur", "sales_channel_id": "sc_01K465NVAAFMSJ0RGP5VCKEPVH", "shipping_address": {"id": "caaddr_01K46A0ZRNPRJP2YKVVCX2RH5W", "city": "varanasi", "phone": "", "company": "", "metadata": null, "province": "up", "address_1": "test", "address_2": "", "last_name": "test", "created_at": "2025-09-02T22:51:08.950Z", "deleted_at": null, "first_name": "test", "updated_at": "2025-09-02T22:51:08.950Z", "customer_id": null, "postal_code": "221002", "country_code": "it"}}]}}}, "validate-presence-of": {"__type": "Symbol(WorkflowWorkflowData)"}, "sales_channels-fulfillment-query": {"__type": "Symbol(WorkflowWorkflowData)", "output": {"__type": "Symbol(WorkflowStepResponse)", "output": {"data": [{"id": "sc_01K465NVAAFMSJ0RGP5VCKEPVH", "stock_locations": [{"id": "sloc_01K465NX02PRA37GR065XPNVC1", "name": "European Warehouse", "address": {"id": "laddr_01K465NX02JG26E8Z5N4C83M68", "city": "Copenhagen", "phone": null, "company": null, "metadata": null, "province": null, "address_1": "", "address_2": null, "created_at": "2025-09-02T21:35:11.362Z", "deleted_at": null, "updated_at": "2025-09-02T21:35:11.362Z", "postal_code": null, "country_code": "DK"}, "fulfillment_sets": [{"id": "fuset_01K465NX0BS3XBXW4G9VJ79T0Z"}]}]}]}, "compensateInput": {"data": [{"id": "sc_01K465NVAAFMSJ0RGP5VCKEPVH", "stock_locations": [{"id": "sloc_01K465NX02PRA37GR065XPNVC1", "name": "European Warehouse", "address": {"id": "laddr_01K465NX02JG26E8Z5N4C83M68", "city": "Copenhagen", "phone": null, "company": null, "metadata": null, "province": null, "address_1": "", "address_2": null, "created_at": "2025-09-02T21:35:11.362Z", "deleted_at": null, "updated_at": "2025-09-02T21:35:11.362Z", "postal_code": null, "country_code": "DK"}, "fulfillment_sets": [{"id": "fuset_01K465NX0BS3XBXW4G9VJ79T0Z"}]}]}]}}}, "shipping-options-query-flat-rate": {"__type": "Symbol(WorkflowWorkflowData)", "output": {"__type": "Symbol(WorkflowStepResponse)", "output": [{"id": "so_01K465NX0W8FHES8P37CAFHZS3", "data": null, "name": "Standard Shipping", "type": {"id": "sotype_01K465NX0WGE47H7NC6TPMQ1VT", "code": "standard", "label": "Standard", "description": "Ship in 2-3 days."}, "rules": [{"value": "true", "operator": "eq", "attribute": "enabled_in_store"}, {"value": "false", "operator": "eq", "attribute": "is_return"}], "prices": [{"id": "price_01K465NX13YV0869BSEMPE88P6", "title": null, "amount": 10, "created_at": "2025-09-02T21:35:11.396Z", "deleted_at": null, "price_list": null, "raw_amount": {"value": "10", "precision": 20}, "updated_at": "2025-09-02T21:35:11.396Z", "price_rules": [], "rules_count": 0, "max_quantity": null, "min_quantity": null, "price_set_id": "pset_01K465NX13CASJ8S3MJ3RY8NN0", "currency_code": "eur", "price_list_id": null}, {"id": "price_01K465NX13NW3SRA7AEEZVFP07", "title": null, "amount": 10, "created_at": "2025-09-02T21:35:11.396Z", "deleted_at": null, "price_list": null, "raw_amount": {"value": "10", "precision": 20}, "updated_at": "2025-09-02T21:35:11.396Z", "price_rules": [{"id": "prule_01K465NX13952QNKKADD38EZ3D", "value": "reg_01K465NWZBB589QBS334WRK4PF", "operator": "eq", "price_id": "price_01K465NX13NW3SRA7AEEZVFP07", "priority": 0, "attribute": "region_id", "created_at": "2025-09-02T21:35:11.396Z", "deleted_at": null, "updated_at": "2025-09-02T21:35:11.396Z"}], "rules_count": 1, "max_quantity": null, "min_quantity": null, "price_set_id": "pset_01K465NX13CASJ8S3MJ3RY8NN0", "currency_code": "eur", "price_list_id": null}, {"id": "price_01K465NX135PCBC1E9Q2P5KJ36", "title": null, "amount": 10, "created_at": "2025-09-02T21:35:11.396Z", "deleted_at": null, "price_list": null, "raw_amount": {"value": "10", "precision": 20}, "updated_at": "2025-09-02T21:35:11.396Z", "price_rules": [], "rules_count": 0, "max_quantity": null, "min_quantity": null, "price_set_id": "pset_01K465NX13CASJ8S3MJ3RY8NN0", "currency_code": "usd", "price_list_id": null}], "provider": {"id": "manual_manual", "is_enabled": true}, "price_type": "flat", "provider_id": "manual_manual", "service_zone": {"id": "serzo_01K465NX0B8X83QPDS4ZNJX86S", "fulfillment_set": {"id": "fuset_01K465NX0BS3XBXW4G9VJ79T0Z", "type": "shipping", "location": {"id": "sloc_01K465NX02PRA37GR065XPNVC1", "address": {"id": "laddr_01K465NX02JG26E8Z5N4C83M68", "city": "Copenhagen", "phone": null, "company": null, "metadata": null, "province": null, "address_1": "", "address_2": null, "created_at": "2025-09-02T21:35:11.362Z", "deleted_at": null, "updated_at": "2025-09-02T21:35:11.362Z", "postal_code": null, "country_code": "DK"}}}, "fulfillment_set_id": "fuset_01K465NX0BS3XBXW4G9VJ79T0Z"}, "service_zone_id": "serzo_01K465NX0B8X83QPDS4ZNJX86S", "calculated_price": {"id": "pset_01K465NX13CASJ8S3MJ3RY8NN0", "currency_code": "eur", "original_price": {"id": "price_01K465NX13NW3SRA7AEEZVFP07", "max_quantity": null, "min_quantity": null, "price_list_id": null, "price_list_type": null}, "original_amount": 10, "calculated_price": {"id": "price_01K465NX13NW3SRA7AEEZVFP07", "max_quantity": null, "min_quantity": null, "price_list_id": null, "price_list_type": null}, "calculated_amount": 10, "raw_original_amount": {"value": "10", "precision": 20}, "raw_calculated_amount": {"value": "10", "precision": 20}, "is_original_price_price_list": false, "is_calculated_price_price_list": false, "is_original_price_tax_inclusive": false, "is_calculated_price_tax_inclusive": false}, "shipping_profile_id": "sp_01K465NSMNCMB3KTQC20148JAW"}], "compensateInput": [{"id": "so_01K465NX0W8FHES8P37CAFHZS3", "data": null, "name": "Standard Shipping", "type": {"id": "sotype_01K465NX0WGE47H7NC6TPMQ1VT", "code": "standard", "label": "Standard", "description": "Ship in 2-3 days."}, "rules": [{"value": "true", "operator": "eq", "attribute": "enabled_in_store"}, {"value": "false", "operator": "eq", "attribute": "is_return"}], "prices": [{"id": "price_01K465NX13YV0869BSEMPE88P6", "title": null, "amount": 10, "created_at": "2025-09-02T21:35:11.396Z", "deleted_at": null, "price_list": null, "raw_amount": {"value": "10", "precision": 20}, "updated_at": "2025-09-02T21:35:11.396Z", "price_rules": [], "rules_count": 0, "max_quantity": null, "min_quantity": null, "price_set_id": "pset_01K465NX13CASJ8S3MJ3RY8NN0", "currency_code": "eur", "price_list_id": null}, {"id": "price_01K465NX13NW3SRA7AEEZVFP07", "title": null, "amount": 10, "created_at": "2025-09-02T21:35:11.396Z", "deleted_at": null, "price_list": null, "raw_amount": {"value": "10", "precision": 20}, "updated_at": "2025-09-02T21:35:11.396Z", "price_rules": [{"id": "prule_01K465NX13952QNKKADD38EZ3D", "value": "reg_01K465NWZBB589QBS334WRK4PF", "operator": "eq", "price_id": "price_01K465NX13NW3SRA7AEEZVFP07", "priority": 0, "attribute": "region_id", "created_at": "2025-09-02T21:35:11.396Z", "deleted_at": null, "updated_at": "2025-09-02T21:35:11.396Z"}], "rules_count": 1, "max_quantity": null, "min_quantity": null, "price_set_id": "pset_01K465NX13CASJ8S3MJ3RY8NN0", "currency_code": "eur", "price_list_id": null}, {"id": "price_01K465NX135PCBC1E9Q2P5KJ36", "title": null, "amount": 10, "created_at": "2025-09-02T21:35:11.396Z", "deleted_at": null, "price_list": null, "raw_amount": {"value": "10", "precision": 20}, "updated_at": "2025-09-02T21:35:11.396Z", "price_rules": [], "rules_count": 0, "max_quantity": null, "min_quantity": null, "price_set_id": "pset_01K465NX13CASJ8S3MJ3RY8NN0", "currency_code": "usd", "price_list_id": null}], "provider": {"id": "manual_manual", "is_enabled": true}, "price_type": "flat", "provider_id": "manual_manual", "service_zone": {"id": "serzo_01K465NX0B8X83QPDS4ZNJX86S", "fulfillment_set": {"id": "fuset_01K465NX0BS3XBXW4G9VJ79T0Z", "type": "shipping", "location": {"id": "sloc_01K465NX02PRA37GR065XPNVC1", "address": {"id": "laddr_01K465NX02JG26E8Z5N4C83M68", "city": "Copenhagen", "phone": null, "company": null, "metadata": null, "province": null, "address_1": "", "address_2": null, "created_at": "2025-09-02T21:35:11.362Z", "deleted_at": null, "updated_at": "2025-09-02T21:35:11.362Z", "postal_code": null, "country_code": "DK"}}}, "fulfillment_set_id": "fuset_01K465NX0BS3XBXW4G9VJ79T0Z"}, "service_zone_id": "serzo_01K465NX0B8X83QPDS4ZNJX86S", "calculated_price": {"id": "pset_01K465NX13CASJ8S3MJ3RY8NN0", "currency_code": "eur", "original_price": {"id": "price_01K465NX13NW3SRA7AEEZVFP07", "max_quantity": null, "min_quantity": null, "price_list_id": null, "price_list_type": null}, "original_amount": 10, "calculated_price": {"id": "price_01K465NX13NW3SRA7AEEZVFP07", "max_quantity": null, "min_quantity": null, "price_list_id": null, "price_list_type": null}, "calculated_amount": 10, "raw_original_amount": {"value": "10", "precision": 20}, "raw_calculated_amount": {"value": "10", "precision": 20}, "is_original_price_price_list": false, "is_calculated_price_price_list": false, "is_original_price_tax_inclusive": false, "is_calculated_price_tax_inclusive": false}, "shipping_profile_id": "sp_01K465NSMNCMB3KTQC20148JAW"}]}}, "calculate-shipping-options-prices": {"__type": "Symbol(WorkflowWorkflowData)", "output": {"__type": "Symbol(WorkflowStepResponse)", "output": [], "compensateInput": []}}, "shipping-options-price-type-query": {"__type": "Symbol(WorkflowWorkflowData)", "output": {"__type": "Symbol(WorkflowStepResponse)", "output": [{"id": "so_01K465NX0W8FHES8P37CAFHZS3", "price_type": "flat"}], "compensateInput": [{"id": "so_01K465NX0W8FHES8P37CAFHZS3", "price_type": "flat"}]}}, "shipping-options-query-calculated": {"__type": "Symbol(WorkflowWorkflowData)", "output": {"__type": "Symbol(WorkflowStepResponse)", "output": [], "compensateInput": []}}}, "payload": {"cart_id": "cart_01K466AXHFNSF95BC7REXFZ8B0", "options": [{"id": "so_01K465NX0W8FHES8P37CAFHZS3", "data": {}}], "is_return": false}, "compensate": {}}, "modelId": "list-shipping-options-for-cart-with-pricing", "payload": {"cart_id": "cart_01K466AXHFNSF95BC7REXFZ8B0", "options": [{"id": "so_01K465NX0W8FHES8P37CAFHZS3", "data": {}}], "is_return": false}, "_eventsCount": 0, "transactionId": "list-shipping-options-for-cart-with-pricing-as-step-refresh-cart-shipping-methods-as-step-refresh-cart-items-as-step-auto-01K46A12RDRJXRB1Y1TVQRHRSN"}}}}}, "payload": {"cart": {"id": "cart_01K466AXHFNSF95BC7REXFZ8B0", "items": [{"id": "cali_01K468ECQFE8SQKS9467B5AD66", "title": "Medusa T-Shirt", "total": 10, "cart_id": "cart_01K466AXHFNSF95BC7REXFZ8B0", "product": {"id": "prod_01K465NX26VFWW6C9Y3GJN3K6V", "tags": [], "type_id": null, "categories": [], "is_giftcard": false, "collection_id": null}, "variant": {"id": "variant_01K465NX36QVW4VT9ZBR1WEYPA", "width": null, "height": null, "length": null, "weight": null, "product": {"id": "prod_01K465NX26VFWW6C9Y3GJN3K6V"}, "material": null, "product_id": "prod_01K465NX26VFWW6C9Y3GJN3K6V"}, "metadata": {}, "quantity": 1, "subtitle": "M / Black", "subtotal": 10, "raw_total": {"value": "10", "precision": 20}, "tax_lines": [], "tax_total": 0, "thumbnail": "https://medusa-public-images.s3.eu-west-1.amazonaws.com/tee-black-front.png", "created_at": "2025-09-02T22:23:31.055Z", "deleted_at": null, "product_id": "prod_01K465NX26VFWW6C9Y3GJN3K6V", "unit_price": 10, "updated_at": "2025-09-02T22:23:31.055Z", "variant_id": "variant_01K465NX36QVW4VT9ZBR1WEYPA", "adjustments": [], "is_giftcard": false, "variant_sku": "SHIRT-M-BLACK", "product_type": null, "raw_subtotal": {"value": "10", "precision": 20}, "product_title": "Medusa T-Shirt", "raw_tax_total": {"value": "0", "precision": 20}, "variant_title": "M / Black", "discount_total": 0, "original_total": 10, "product_handle": "t-shirt", "raw_unit_price": {"value": "10", "precision": 20}, "is_custom_price": false, "is_discountable": true, "product_type_id": null, "variant_barcode": null, "is_tax_inclusive": false, "product_subtitle": null, "discount_subtotal": 0, "requires_shipping": true, "discount_tax_total": 0, "original_tax_total": 0, "product_collection": null, "raw_discount_total": {"value": "0", "precision": 20}, "raw_original_total": {"value": "10", "precision": 20}, "product_description": "Reimagine the feeling of a classic T-shirt. With our cotton T-shirts, everyday essentials no longer have to be ordinary.", "compare_at_unit_price": null, "raw_discount_subtotal": {"value": "0", "precision": 20}, "variant_option_values": null, "raw_discount_tax_total": {"value": "0", "precision": 20}, "raw_original_tax_total": {"value": "0", "precision": 20}, "raw_compare_at_unit_price": null}], "total": 20, "region": {"id": "reg_01K465NWZBB589QBS334WRK4PF", "name": "Europe", "metadata": null, "created_at": "2025-09-02T21:35:11.341Z", "deleted_at": null, "updated_at": "2025-09-02T21:35:11.341Z", "currency_code": "eur", "automatic_taxes": true}, "customer": {"id": "cus_01K46A0ZPRWKCSMQAW51DY0W8R", "email": "mk@mk.com", "phone": null, "groups": [], "metadata": null, "last_name": null, "created_at": "2025-09-02T22:51:08.888Z", "created_by": null, "deleted_at": null, "first_name": null, "updated_at": "2025-09-02T22:51:08.888Z", "has_account": false, "company_name": null}, "metadata": null, "subtotal": 20, "region_id": "reg_01K465NWZBB589QBS334WRK4PF", "item_total": 10, "promotions": [], "customer_id": "cus_01K46A0ZPRWKCSMQAW51DY0W8R", "completed_at": null, "currency_code": "eur", "item_subtotal": 10, "sales_channel_id": "sc_01K465NVAAFMSJ0RGP5VCKEPVH", "shipping_address": {"id": "caaddr_01K46A0ZRNPRJP2YKVVCX2RH5W", "city": "varanasi", "phone": "", "company": "", "metadata": null, "province": "up", "address_1": "test", "address_2": "", "last_name": "test", "created_at": "2025-09-02T22:51:08.950Z", "deleted_at": null, "first_name": "test", "updated_at": "2025-09-02T22:51:08.950Z", "customer_id": null, "postal_code": "221002", "country_code": "it"}, "shipping_methods": [{"id": "casm_01K46A12WMTEF0WW2GPAESHJ3N", "data": {}, "name": "Standard Shipping", "total": 10, "amount": 10, "cart_id": "cart_01K466AXHFNSF95BC7REXFZ8B0", "metadata": null, "subtotal": 10, "raw_total": {"value": "10", "precision": 20}, "tax_lines": [], "tax_total": 0, "created_at": "2025-09-02T22:51:12.148Z", "deleted_at": null, "raw_amount": {"value": "10", "precision": 20}, "updated_at": "2025-09-02T22:51:12.148Z", "adjustments": [], "description": null, "raw_subtotal": {"value": "10", "precision": 20}, "raw_tax_total": {"value": "0", "precision": 20}, "discount_total": 0, "original_total": 10, "shipping_option": {"id": "so_01K465NX0W8FHES8P37CAFHZS3", "shipping_option_type_id": "sotype_01K465NX0WGE47H7NC6TPMQ1VT"}, "is_tax_inclusive": false, "discount_subtotal": 0, "discount_tax_total": 0, "original_tax_total": 0, "raw_discount_total": {"value": "0", "precision": 20}, "raw_original_total": {"value": "10", "precision": 20}, "shipping_option_id": "so_01K465NX0W8FHES8P37CAFHZS3", "raw_discount_subtotal": {"value": "0", "precision": 20}, "raw_discount_tax_total": {"value": "0", "precision": 20}, "raw_original_tax_total": {"value": "0", "precision": 20}}], "shipping_subtotal": 10}}, "compensate": {}}, "modelId": "refresh-cart-shipping-methods", "payload": {"cart": {"id": "cart_01K466AXHFNSF95BC7REXFZ8B0", "items": [{"id": "cali_01K468ECQFE8SQKS9467B5AD66", "title": "Medusa T-Shirt", "total": 10, "cart_id": "cart_01K466AXHFNSF95BC7REXFZ8B0", "product": {"id": "prod_01K465NX26VFWW6C9Y3GJN3K6V", "tags": [], "type_id": null, "categories": [], "is_giftcard": false, "collection_id": null}, "variant": {"id": "variant_01K465NX36QVW4VT9ZBR1WEYPA", "width": null, "height": null, "length": null, "weight": null, "product": {"id": "prod_01K465NX26VFWW6C9Y3GJN3K6V"}, "material": null, "product_id": "prod_01K465NX26VFWW6C9Y3GJN3K6V"}, "metadata": {}, "quantity": 1, "subtitle": "M / Black", "subtotal": 10, "raw_total": {"value": "10", "precision": 20}, "tax_lines": [], "tax_total": 0, "thumbnail": "https://medusa-public-images.s3.eu-west-1.amazonaws.com/tee-black-front.png", "created_at": "2025-09-02T22:23:31.055Z", "deleted_at": null, "product_id": "prod_01K465NX26VFWW6C9Y3GJN3K6V", "unit_price": 10, "updated_at": "2025-09-02T22:23:31.055Z", "variant_id": "variant_01K465NX36QVW4VT9ZBR1WEYPA", "adjustments": [], "is_giftcard": false, "variant_sku": "SHIRT-M-BLACK", "product_type": null, "raw_subtotal": {"value": "10", "precision": 20}, "product_title": "Medusa T-Shirt", "raw_tax_total": {"value": "0", "precision": 20}, "variant_title": "M / Black", "discount_total": 0, "original_total": 10, "product_handle": "t-shirt", "raw_unit_price": {"value": "10", "precision": 20}, "is_custom_price": false, "is_discountable": true, "product_type_id": null, "variant_barcode": null, "is_tax_inclusive": false, "product_subtitle": null, "discount_subtotal": 0, "requires_shipping": true, "discount_tax_total": 0, "original_tax_total": 0, "product_collection": null, "raw_discount_total": {"value": "0", "precision": 20}, "raw_original_total": {"value": "10", "precision": 20}, "product_description": "Reimagine the feeling of a classic T-shirt. With our cotton T-shirts, everyday essentials no longer have to be ordinary.", "compare_at_unit_price": null, "raw_discount_subtotal": {"value": "0", "precision": 20}, "variant_option_values": null, "raw_discount_tax_total": {"value": "0", "precision": 20}, "raw_original_tax_total": {"value": "0", "precision": 20}, "raw_compare_at_unit_price": null}], "total": 20, "region": {"id": "reg_01K465NWZBB589QBS334WRK4PF", "name": "Europe", "metadata": null, "created_at": "2025-09-02T21:35:11.341Z", "deleted_at": null, "updated_at": "2025-09-02T21:35:11.341Z", "currency_code": "eur", "automatic_taxes": true}, "customer": {"id": "cus_01K46A0ZPRWKCSMQAW51DY0W8R", "email": "mk@mk.com", "phone": null, "groups": [], "metadata": null, "last_name": null, "created_at": "2025-09-02T22:51:08.888Z", "created_by": null, "deleted_at": null, "first_name": null, "updated_at": "2025-09-02T22:51:08.888Z", "has_account": false, "company_name": null}, "metadata": null, "subtotal": 20, "region_id": "reg_01K465NWZBB589QBS334WRK4PF", "item_total": 10, "promotions": [], "customer_id": "cus_01K46A0ZPRWKCSMQAW51DY0W8R", "completed_at": null, "currency_code": "eur", "item_subtotal": 10, "sales_channel_id": "sc_01K465NVAAFMSJ0RGP5VCKEPVH", "shipping_address": {"id": "caaddr_01K46A0ZRNPRJP2YKVVCX2RH5W", "city": "varanasi", "phone": "", "company": "", "metadata": null, "province": "up", "address_1": "test", "address_2": "", "last_name": "test", "created_at": "2025-09-02T22:51:08.950Z", "deleted_at": null, "first_name": "test", "updated_at": "2025-09-02T22:51:08.950Z", "customer_id": null, "postal_code": "221002", "country_code": "it"}, "shipping_methods": [{"id": "casm_01K46A12WMTEF0WW2GPAESHJ3N", "data": {}, "name": "Standard Shipping", "total": 10, "amount": 10, "cart_id": "cart_01K466AXHFNSF95BC7REXFZ8B0", "metadata": null, "subtotal": 10, "raw_total": {"value": "10", "precision": 20}, "tax_lines": [], "tax_total": 0, "created_at": "2025-09-02T22:51:12.148Z", "deleted_at": null, "raw_amount": {"value": "10", "precision": 20}, "updated_at": "2025-09-02T22:51:12.148Z", "adjustments": [], "description": null, "raw_subtotal": {"value": "10", "precision": 20}, "raw_tax_total": {"value": "0", "precision": 20}, "discount_total": 0, "original_total": 10, "shipping_option": {"id": "so_01K465NX0W8FHES8P37CAFHZS3", "shipping_option_type_id": "sotype_01K465NX0WGE47H7NC6TPMQ1VT"}, "is_tax_inclusive": false, "discount_subtotal": 0, "discount_tax_total": 0, "original_tax_total": 0, "raw_discount_total": {"value": "0", "precision": 20}, "raw_original_total": {"value": "10", "precision": 20}, "shipping_option_id": "so_01K465NX0W8FHES8P37CAFHZS3", "raw_discount_subtotal": {"value": "0", "precision": 20}, "raw_discount_tax_total": {"value": "0", "precision": 20}, "raw_original_tax_total": {"value": "0", "precision": 20}}], "shipping_subtotal": 10}}, "_eventsCount": 0, "transactionId": "refresh-cart-shipping-methods-as-step-refresh-cart-items-as-step-auto-01K46A12RDRJXRB1Y1TVQRHRSN"}}}}, "refresh-payment-collection-for-cart-as-step": {"__type": "Symbol(WorkflowWorkflowData)", "output": {"__type": "Symbol(WorkflowStepResponse)", "compensateInput": {"errors": [], "thrownError": null, "transaction": {"flow": {"runId": "01K46A12RF3RVEMTWBR7A89T82", "state": "done", "steps": {"_root": {"id": "_root", "next": ["_root.use-remote-query"]}, "_root.use-remote-query": {"id": "_root.use-remote-query", "next": ["_root.use-remote-query.validate"], "uuid": "01K469C7MYE6F5K2A9J8T5ANE7", "depth": 1, "invoke": {"state": "done", "status": "ok"}, "attempts": 1, "failures": 0, "startedAt": 1756853472616, "compensate": {"state": "dormant", "status": "idle"}, "definition": {"uuid": "01K469C7MYE6F5K2A9J8T5ANE7", "action": "use-remote-query", "noCompensation": true}, "stepFailed": false, "lastAttempt": 1756853472616, "saveResponse": true}, "_root.use-remote-query.validate": {"id": "_root.use-remote-query.validate", "next": ["_root.use-remote-query.validate.delete-payment-sessions-as-step", "_root.use-remote-query.validate.update-payment-collection"], "uuid": "01K469C7MYP3P45ZM4P72S2XKS", "depth": 2, "invoke": {"state": "done", "status": "ok"}, "attempts": 1, "failures": 0, "startedAt": 1756853472628, "compensate": {"state": "dormant", "status": "idle"}, "definition": {"uuid": "01K469C7MYP3P45ZM4P72S2XKS", "action": "validate", "noCompensation": false}, "stepFailed": false, "lastAttempt": 1756853472628, "saveResponse": true}, "_root.use-remote-query.validate.update-payment-collection": {"id": "_root.use-remote-query.validate.update-payment-collection", "next": [], "uuid": "01K469C7MYBEYF34R5J2GCFD10", "depth": 3, "invoke": {"state": "done", "status": "ok"}, "attempts": 1, "failures": 0, "startedAt": 1756853472633, "compensate": {"state": "dormant", "status": "idle"}, "definition": {"uuid": "01K469C7MYBEYF34R5J2GCFD10", "action": "update-payment-collection", "noCompensation": false}, "stepFailed": false, "lastAttempt": 1756853472633, "saveResponse": true}, "_root.use-remote-query.validate.delete-payment-sessions-as-step": {"id": "_root.use-remote-query.validate.delete-payment-sessions-as-step", "next": [], "uuid": "01K469C7MYJ7W7X0X2VZ7HA3V2", "depth": 3, "invoke": {"state": "done", "status": "ok"}, "attempts": 1, "failures": 0, "startedAt": 1756853472633, "compensate": {"state": "dormant", "status": "idle"}, "definition": {"name": "delete-payment-sessions-as-step", "uuid": "01K469C7MYJ7W7X0X2VZ7HA3V2", "async": false, "action": "delete-payment-sessions-as-step", "nested": false, "noCompensation": false}, "stepFailed": false, "lastAttempt": 1756853472633, "saveResponse": true}}, "modelId": "refresh-payment-collection-for-cart", "options": {"name": "refresh-payment-collection-for-cart", "store": true, "idempotent": true}, "metadata": {"sourcePath": "/Users/mukul/Documents/GitHub/pharmint-marketplace/backend/node_modules/@medusajs/core-flows/dist/cart/workflows/refresh-payment-collection.js", "eventGroupId": "01K46A12RD5DTAJW3P0DEHRKZB", "preventReleaseEvents": true, "parentStepIdempotencyKey": "refresh-cart-items:refresh-cart-items-as-step-auto-01K46A12RDRJXRB1Y1TVQRHRSN:refresh-payment-collection-for-cart-as-step:invoke"}, "startedAt": 1756853472613, "definition": {"next": {"next": [{"name": "delete-payment-sessions-as-step", "uuid": "01K469C7MYJ7W7X0X2VZ7HA3V2", "async": false, "action": "delete-payment-sessions-as-step", "nested": false, "noCompensation": false}, {"uuid": "01K469C7MYBEYF34R5J2GCFD10", "action": "update-payment-collection", "noCompensation": false}], "uuid": "01K469C7MYP3P45ZM4P72S2XKS", "action": "validate", "noCompensation": false}, "uuid": "01K469C7MYE6F5K2A9J8T5ANE7", "action": "use-remote-query", "noCompensation": true}, "timedOutAt": null, "hasAsyncSteps": false, "transactionId": "refresh-payment-collection-for-cart-as-step-refresh-cart-items-as-step-auto-01K46A12RDRJXRB1Y1TVQRHRSN", "hasFailedSteps": false, "hasSkippedSteps": false, "hasWaitingSteps": false, "hasRevertedSteps": false, "hasSkippedOnFailureSteps": false}, "runId": "01K46A12RF3RVEMTWBR7A89T82", "errors": [], "_events": {}, "context": {"invoke": {"validate": {"__type": "Symbol(WorkflowWorkflowData)", "output": {"__type": "Symbol(WorkflowStepResponse)"}}, "use-remote-query": {"__type": "Symbol(WorkflowWorkflowData)", "output": {"__type": "Symbol(WorkflowStepResponse)", "output": {"id": "cart_01K466AXHFNSF95BC7REXFZ8B0", "total": 20, "raw_total": {"value": "20", "precision": 20}, "region_id": "reg_01K465NWZBB589QBS334WRK4PF", "currency_code": "eur"}, "compensateInput": {"id": "cart_01K466AXHFNSF95BC7REXFZ8B0", "total": 20, "raw_total": {"value": "20", "precision": 20}, "region_id": "reg_01K465NWZBB589QBS334WRK4PF", "currency_code": "eur"}}}, "update-payment-collection": {"__type": "Symbol(WorkflowWorkflowData)", "output": {"__type": "Symbol(WorkflowStepResponse)", "output": [], "compensateInput": []}}, "delete-payment-sessions-as-step": {"__type": "Symbol(WorkflowWorkflowData)", "output": {"__type": "Symbol(WorkflowStepResponse)", "output": [], "compensateInput": {"errors": [], "result": [], "thrownError": null, "transaction": {"flow": {"runId": "01K46A12RF3RVEMTWBR7A89T82", "state": "done", "steps": {"_root": {"id": "_root", "next": ["_root.delete-payment-sessions"]}, "_root.delete-payment-sessions": {"id": "_root.delete-payment-sessions", "next": ["_root.delete-payment-sessions.validate-deleted-payment-sessions"], "uuid": "01K469C7MW8WCT5KNWMBT8NWF4", "depth": 1, "invoke": {"state": "done", "status": "ok"}, "attempts": 1, "failures": 0, "startedAt": 1756853472636, "compensate": {"state": "dormant", "status": "idle"}, "definition": {"uuid": "01K469C7MW8WCT5KNWMBT8NWF4", "action": "delete-payment-sessions", "noCompensation": false}, "stepFailed": false, "lastAttempt": 1756853472636, "saveResponse": true}, "_root.delete-payment-sessions.validate-deleted-payment-sessions": {"id": "_root.delete-payment-sessions.validate-deleted-payment-sessions", "next": [], "uuid": "01K469C7MWVT1ZWZRD399W09VN", "depth": 2, "invoke": {"state": "done", "status": "ok"}, "attempts": 1, "failures": 0, "startedAt": 1756853472636, "compensate": {"state": "dormant", "status": "idle"}, "definition": {"uuid": "01K469C7MWVT1ZWZRD399W09VN", "action": "validate-deleted-payment-sessions", "noCompensation": true}, "stepFailed": false, "lastAttempt": 1756853472636, "saveResponse": true}}, "modelId": "delete-payment-sessions", "options": {}, "metadata": {"sourcePath": "/Users/mukul/Documents/GitHub/pharmint-marketplace/backend/node_modules/@medusajs/core-flows/dist/payment-collection/workflows/delete-payment-sessions.js", "eventGroupId": "01K46A12RD5DTAJW3P0DEHRKZB", "preventReleaseEvents": true, "parentStepIdempotencyKey": "refresh-payment-collection-for-cart:refresh-payment-collection-for-cart-as-step-refresh-cart-items-as-step-auto-01K46A12RDRJXRB1Y1TVQRHRSN:delete-payment-sessions-as-step:invoke"}, "startedAt": 1756853472636, "definition": {"next": {"uuid": "01K469C7MWVT1ZWZRD399W09VN", "action": "validate-deleted-payment-sessions", "noCompensation": true}, "uuid": "01K469C7MW8WCT5KNWMBT8NWF4", "action": "delete-payment-sessions", "noCompensation": false}, "timedOutAt": null, "hasAsyncSteps": false, "transactionId": "delete-payment-sessions-as-step-refresh-payment-collection-for-cart-as-step-refresh-cart-items-as-step-auto-01K46A12RDRJXRB1Y1TVQRHRSN", "hasFailedSteps": false, "hasSkippedSteps": false, "hasWaitingSteps": false, "hasRevertedSteps": false, "hasSkippedOnFailureSteps": false}, "runId": "01K46A12RF3RVEMTWBR7A89T82", "errors": [], "_events": {}, "context": {"invoke": {"delete-payment-sessions": {"__type": "Symbol(WorkflowWorkflowData)", "output": {"__type": "Symbol(WorkflowStepResponse)", "output": [], "compensateInput": null}}, "validate-deleted-payment-sessions": {"__type": "Symbol(WorkflowWorkflowData)", "output": {"__type": "Symbol(WorkflowStepResponse)"}}}, "payload": {"ids": []}, "compensate": {}}, "modelId": "delete-payment-sessions", "payload": {"ids": []}, "_eventsCount": 0, "transactionId": "delete-payment-sessions-as-step-refresh-payment-collection-for-cart-as-step-refresh-cart-items-as-step-auto-01K46A12RDRJXRB1Y1TVQRHRSN"}}}}}, "payload": {"cart_id": "cart_01K466AXHFNSF95BC7REXFZ8B0"}, "compensate": {}}, "modelId": "refresh-payment-collection-for-cart", "payload": {"cart_id": "cart_01K466AXHFNSF95BC7REXFZ8B0"}, "_eventsCount": 0, "transactionId": "refresh-payment-collection-for-cart-as-step-refresh-cart-items-as-step-auto-01K46A12RDRJXRB1Y1TVQRHRSN"}}}}}, "payload": {"cart_id": "cart_01K466AXHFNSF95BC7REXFZ8B0", "shipping_methods": [{"id": "casm_01K46A12WMTEF0WW2GPAESHJ3N", "data": {}, "name": "Standard Shipping", "amount": 10, "cart_id": "cart_01K466AXHFNSF95BC7REXFZ8B0", "metadata": null, "tax_lines": [], "created_at": "2025-09-02T22:51:12.148Z", "deleted_at": null, "raw_amount": {"value": "10", "precision": 20}, "updated_at": "2025-09-02T22:51:12.148Z", "adjustments": [], "description": null, "is_tax_inclusive": false, "shipping_option_id": "so_01K465NX0W8FHES8P37CAFHZS3"}]}, "compensate": {}}, "errors": []}	done	2025-09-02 22:51:12.157	2025-09-02 22:51:12.671	\N	\N	01K46A12RF3RVEMTWBR7A89T82
wf_exec_01K46AAXJQR19ZM25EJG8MXE5F	update-cart-promotions	update-cart-promotions-as-step-auto-01K46AAXGME6SGPZN47WAWQPXX	{"runId": "01K46AAXGX5F9FC7KY368E20F2", "state": "done", "steps": {"_root": {"id": "_root", "next": ["_root.use-remote-query"]}, "_root.use-remote-query": {"id": "_root.use-remote-query", "next": ["_root.use-remote-query.validate"], "uuid": "01K469C7MZRTB0J3E7K3J0NKVN", "depth": 1, "invoke": {"state": "done", "status": "ok"}, "attempts": 1, "failures": 0, "startedAt": 1756853794399, "compensate": {"state": "dormant", "status": "idle"}, "definition": {"uuid": "01K469C7MZRTB0J3E7K3J0NKVN", "action": "use-remote-query", "noCompensation": true}, "stepFailed": false, "lastAttempt": 1756853794399, "saveResponse": true}, "_root.use-remote-query.validate": {"id": "_root.use-remote-query.validate", "next": ["_root.use-remote-query.validate.get-promotion-codes-to-apply"], "uuid": "01K469C7MZZ7DZ9NJTQXHXQBKM", "depth": 2, "invoke": {"state": "done", "status": "ok"}, "attempts": 1, "failures": 0, "startedAt": 1756853794428, "compensate": {"state": "dormant", "status": "idle"}, "definition": {"uuid": "01K469C7MZZ7DZ9NJTQXHXQBKM", "action": "validate", "noCompensation": false}, "stepFailed": false, "lastAttempt": 1756853794428, "saveResponse": true}, "_root.use-remote-query.validate.get-promotion-codes-to-apply": {"id": "_root.use-remote-query.validate.get-promotion-codes-to-apply", "next": ["_root.use-remote-query.validate.get-promotion-codes-to-apply.get-actions-to-compute-from-promotions"], "uuid": "01K469C7MZZEZVY9PFRV35WWVP", "depth": 3, "invoke": {"state": "done", "status": "ok"}, "attempts": 1, "failures": 0, "startedAt": 1756853794434, "compensate": {"state": "dormant", "status": "idle"}, "definition": {"uuid": "01K469C7MZZEZVY9PFRV35WWVP", "action": "get-promotion-codes-to-apply", "noCompensation": true}, "stepFailed": false, "lastAttempt": 1756853794434, "saveResponse": true}, "_root.use-remote-query.validate.get-promotion-codes-to-apply.get-actions-to-compute-from-promotions": {"id": "_root.use-remote-query.validate.get-promotion-codes-to-apply.get-actions-to-compute-from-promotions", "next": ["_root.use-remote-query.validate.get-promotion-codes-to-apply.get-actions-to-compute-from-promotions.prepare-adjustments-from-promotion-actions"], "uuid": "01K469C7MZ230XVA7CPQMNBBZK", "depth": 4, "invoke": {"state": "done", "status": "ok"}, "attempts": 1, "failures": 0, "startedAt": 1756853794440, "compensate": {"state": "dormant", "status": "idle"}, "definition": {"uuid": "01K469C7MZ230XVA7CPQMNBBZK", "action": "get-actions-to-compute-from-promotions", "noCompensation": true}, "stepFailed": false, "lastAttempt": 1756853794440, "saveResponse": true}, "_root.use-remote-query.validate.get-promotion-codes-to-apply.get-actions-to-compute-from-promotions.prepare-adjustments-from-promotion-actions": {"id": "_root.use-remote-query.validate.get-promotion-codes-to-apply.get-actions-to-compute-from-promotions.prepare-adjustments-from-promotion-actions", "next": ["_root.use-remote-query.validate.get-promotion-codes-to-apply.get-actions-to-compute-from-promotions.prepare-adjustments-from-promotion-actions.remove-line-item-adjustments", "_root.use-remote-query.validate.get-promotion-codes-to-apply.get-actions-to-compute-from-promotions.prepare-adjustments-from-promotion-actions.remove-shipping-method-adjustments", "_root.use-remote-query.validate.get-promotion-codes-to-apply.get-actions-to-compute-from-promotions.prepare-adjustments-from-promotion-actions.create-line-item-adjustments", "_root.use-remote-query.validate.get-promotion-codes-to-apply.get-actions-to-compute-from-promotions.prepare-adjustments-from-promotion-actions.create-shipping-method-adjustments", "_root.use-remote-query.validate.get-promotion-codes-to-apply.get-actions-to-compute-from-promotions.prepare-adjustments-from-promotion-actions.update-cart-promotions"], "uuid": "01K469C7MZP1FZ49MXK5KS5WE8", "depth": 5, "invoke": {"state": "done", "status": "ok"}, "attempts": 1, "failures": 0, "startedAt": 1756853794457, "compensate": {"state": "dormant", "status": "idle"}, "definition": {"uuid": "01K469C7MZP1FZ49MXK5KS5WE8", "action": "prepare-adjustments-from-promotion-actions", "noCompensation": true}, "stepFailed": false, "lastAttempt": 1756853794457, "saveResponse": true}, "_root.use-remote-query.validate.get-promotion-codes-to-apply.get-actions-to-compute-from-promotions.prepare-adjustments-from-promotion-actions.update-cart-promotions": {"id": "_root.use-remote-query.validate.get-promotion-codes-to-apply.get-actions-to-compute-from-promotions.prepare-adjustments-from-promotion-actions.update-cart-promotions", "next": [], "uuid": "01K469C7MZJGSJ03P98Z1WX96N", "depth": 6, "invoke": {"state": "done", "status": "ok"}, "attempts": 1, "failures": 0, "startedAt": 1756853794463, "compensate": {"state": "dormant", "status": "idle"}, "definition": {"uuid": "01K469C7MZJGSJ03P98Z1WX96N", "action": "update-cart-promotions", "noCompensation": false}, "stepFailed": false, "lastAttempt": 1756853794463, "saveResponse": true}, "_root.use-remote-query.validate.get-promotion-codes-to-apply.get-actions-to-compute-from-promotions.prepare-adjustments-from-promotion-actions.create-line-item-adjustments": {"id": "_root.use-remote-query.validate.get-promotion-codes-to-apply.get-actions-to-compute-from-promotions.prepare-adjustments-from-promotion-actions.create-line-item-adjustments", "next": [], "uuid": "01K469C7MZXZCWKF2H3VYG92D9", "depth": 6, "invoke": {"state": "done", "status": "ok"}, "attempts": 1, "failures": 0, "startedAt": 1756853794463, "compensate": {"state": "dormant", "status": "idle"}, "definition": {"uuid": "01K469C7MZXZCWKF2H3VYG92D9", "action": "create-line-item-adjustments", "noCompensation": false}, "stepFailed": false, "lastAttempt": 1756853794463, "saveResponse": true}, "_root.use-remote-query.validate.get-promotion-codes-to-apply.get-actions-to-compute-from-promotions.prepare-adjustments-from-promotion-actions.remove-line-item-adjustments": {"id": "_root.use-remote-query.validate.get-promotion-codes-to-apply.get-actions-to-compute-from-promotions.prepare-adjustments-from-promotion-actions.remove-line-item-adjustments", "next": [], "uuid": "01K469C7MZVTP07XXFPT7GTEAN", "depth": 6, "invoke": {"state": "done", "status": "ok"}, "attempts": 1, "failures": 0, "startedAt": 1756853794463, "compensate": {"state": "dormant", "status": "idle"}, "definition": {"uuid": "01K469C7MZVTP07XXFPT7GTEAN", "action": "remove-line-item-adjustments", "noCompensation": false}, "stepFailed": false, "lastAttempt": 1756853794463, "saveResponse": true}, "_root.use-remote-query.validate.get-promotion-codes-to-apply.get-actions-to-compute-from-promotions.prepare-adjustments-from-promotion-actions.create-shipping-method-adjustments": {"id": "_root.use-remote-query.validate.get-promotion-codes-to-apply.get-actions-to-compute-from-promotions.prepare-adjustments-from-promotion-actions.create-shipping-method-adjustments", "next": [], "uuid": "01K469C7MZBETCGP1B1XFG2GAH", "depth": 6, "invoke": {"state": "done", "status": "ok"}, "attempts": 1, "failures": 0, "startedAt": 1756853794463, "compensate": {"state": "dormant", "status": "idle"}, "definition": {"uuid": "01K469C7MZBETCGP1B1XFG2GAH", "action": "create-shipping-method-adjustments", "noCompensation": false}, "stepFailed": false, "lastAttempt": 1756853794463, "saveResponse": true}, "_root.use-remote-query.validate.get-promotion-codes-to-apply.get-actions-to-compute-from-promotions.prepare-adjustments-from-promotion-actions.remove-shipping-method-adjustments": {"id": "_root.use-remote-query.validate.get-promotion-codes-to-apply.get-actions-to-compute-from-promotions.prepare-adjustments-from-promotion-actions.remove-shipping-method-adjustments", "next": [], "uuid": "01K469C7MZH7W9A6EVXK2SEVDY", "depth": 6, "invoke": {"state": "done", "status": "ok"}, "attempts": 1, "failures": 0, "startedAt": 1756853794463, "compensate": {"state": "dormant", "status": "idle"}, "definition": {"uuid": "01K469C7MZH7W9A6EVXK2SEVDY", "action": "remove-shipping-method-adjustments", "noCompensation": false}, "stepFailed": false, "lastAttempt": 1756853794463, "saveResponse": true}}, "modelId": "update-cart-promotions", "options": {"name": "update-cart-promotions", "store": true, "idempotent": true}, "metadata": {"sourcePath": "/Users/mukul/Documents/GitHub/pharmint-marketplace/backend/node_modules/@medusajs/core-flows/dist/cart/workflows/update-cart-promotions.js", "eventGroupId": "01K46AAXGMPJJDPCHR5ZPHJ132", "preventReleaseEvents": true, "parentStepIdempotencyKey": "create-cart:auto-01K46AAXGME6SGPZN47WAWQPXX:update-cart-promotions-as-step:invoke"}, "startedAt": 1756853794394, "definition": {"next": {"next": {"next": {"next": {"next": [{"uuid": "01K469C7MZVTP07XXFPT7GTEAN", "action": "remove-line-item-adjustments", "noCompensation": false}, {"uuid": "01K469C7MZH7W9A6EVXK2SEVDY", "action": "remove-shipping-method-adjustments", "noCompensation": false}, {"uuid": "01K469C7MZXZCWKF2H3VYG92D9", "action": "create-line-item-adjustments", "noCompensation": false}, {"uuid": "01K469C7MZBETCGP1B1XFG2GAH", "action": "create-shipping-method-adjustments", "noCompensation": false}, {"uuid": "01K469C7MZJGSJ03P98Z1WX96N", "action": "update-cart-promotions", "noCompensation": false}], "uuid": "01K469C7MZP1FZ49MXK5KS5WE8", "action": "prepare-adjustments-from-promotion-actions", "noCompensation": true}, "uuid": "01K469C7MZ230XVA7CPQMNBBZK", "action": "get-actions-to-compute-from-promotions", "noCompensation": true}, "uuid": "01K469C7MZZEZVY9PFRV35WWVP", "action": "get-promotion-codes-to-apply", "noCompensation": true}, "uuid": "01K469C7MZZ7DZ9NJTQXHXQBKM", "action": "validate", "noCompensation": false}, "uuid": "01K469C7MZRTB0J3E7K3J0NKVN", "action": "use-remote-query", "noCompensation": true}, "timedOutAt": null, "hasAsyncSteps": false, "transactionId": "update-cart-promotions-as-step-auto-01K46AAXGME6SGPZN47WAWQPXX", "hasFailedSteps": false, "hasSkippedSteps": false, "hasWaitingSteps": false, "hasRevertedSteps": false, "hasSkippedOnFailureSteps": false}	{"data": {"invoke": {"validate": {"__type": "Symbol(WorkflowWorkflowData)", "output": {"__type": "Symbol(WorkflowStepResponse)"}}, "use-remote-query": {"__type": "Symbol(WorkflowWorkflowData)", "output": {"__type": "Symbol(WorkflowStepResponse)", "output": {"id": "cart_01K46AAXHDHBT18YFJSZZDTR33", "items": [], "total": 0, "region": {"id": "reg_01K465NWZBB589QBS334WRK4PF", "name": "Europe", "metadata": null, "created_at": "2025-09-02T21:35:11.341Z", "deleted_at": null, "updated_at": "2025-09-02T21:35:11.341Z", "currency_code": "eur", "automatic_taxes": true}, "customer": {"id": "cus_01K46A3BBP2PYVPB81ECAQ2CVM", "email": "mk24x7@gmail.com", "phone": "+448005251034", "groups": [], "metadata": null, "last_name": "Yadav", "created_at": "2025-09-02T22:52:26.358Z", "created_by": null, "deleted_at": null, "first_name": "Mukul", "updated_at": "2025-09-02T22:52:26.358Z", "has_account": true, "company_name": null}, "metadata": null, "subtotal": 0, "region_id": "reg_01K465NWZBB589QBS334WRK4PF", "item_total": 0, "promotions": [], "customer_id": "cus_01K46A3BBP2PYVPB81ECAQ2CVM", "completed_at": null, "currency_code": "eur", "item_subtotal": 0, "sales_channel_id": "sc_01K465NVAAFMSJ0RGP5VCKEPVH", "shipping_methods": [], "shipping_subtotal": 0}, "compensateInput": {"id": "cart_01K46AAXHDHBT18YFJSZZDTR33", "items": [], "total": 0, "region": {"id": "reg_01K465NWZBB589QBS334WRK4PF", "name": "Europe", "metadata": null, "created_at": "2025-09-02T21:35:11.341Z", "deleted_at": null, "updated_at": "2025-09-02T21:35:11.341Z", "currency_code": "eur", "automatic_taxes": true}, "customer": {"id": "cus_01K46A3BBP2PYVPB81ECAQ2CVM", "email": "mk24x7@gmail.com", "phone": "+448005251034", "groups": [], "metadata": null, "last_name": "Yadav", "created_at": "2025-09-02T22:52:26.358Z", "created_by": null, "deleted_at": null, "first_name": "Mukul", "updated_at": "2025-09-02T22:52:26.358Z", "has_account": true, "company_name": null}, "metadata": null, "subtotal": 0, "region_id": "reg_01K465NWZBB589QBS334WRK4PF", "item_total": 0, "promotions": [], "customer_id": "cus_01K46A3BBP2PYVPB81ECAQ2CVM", "completed_at": null, "currency_code": "eur", "item_subtotal": 0, "sales_channel_id": "sc_01K465NVAAFMSJ0RGP5VCKEPVH", "shipping_methods": [], "shipping_subtotal": 0}}}, "update-cart-promotions": {"__type": "Symbol(WorkflowWorkflowData)", "output": {"__type": "Symbol(WorkflowStepResponse)", "output": null, "compensateInput": {"createdLinkIds": [], "dismissedLinks": []}}}, "create-line-item-adjustments": {"__type": "Symbol(WorkflowWorkflowData)", "output": {"__type": "Symbol(WorkflowStepResponse)", "output": [], "compensateInput": []}}, "get-promotion-codes-to-apply": {"__type": "Symbol(WorkflowWorkflowData)", "output": {"__type": "Symbol(WorkflowStepResponse)", "output": [], "compensateInput": []}}, "remove-line-item-adjustments": {"__type": "Symbol(WorkflowWorkflowData)", "output": {"__type": "Symbol(WorkflowStepResponse)", "compensateInput": []}}, "create-shipping-method-adjustments": {"__type": "Symbol(WorkflowWorkflowData)", "output": {"__type": "Symbol(WorkflowStepResponse)", "compensateInput": []}}, "remove-shipping-method-adjustments": {"__type": "Symbol(WorkflowWorkflowData)", "output": {"__type": "Symbol(WorkflowStepResponse)", "compensateInput": []}}, "get-actions-to-compute-from-promotions": {"__type": "Symbol(WorkflowWorkflowData)", "output": {"__type": "Symbol(WorkflowStepResponse)", "output": [], "compensateInput": []}}, "prepare-adjustments-from-promotion-actions": {"__type": "Symbol(WorkflowWorkflowData)", "output": {"__type": "Symbol(WorkflowStepResponse)", "output": {"computedPromotionCodes": [], "lineItemAdjustmentsToCreate": [], "lineItemAdjustmentIdsToRemove": [], "shippingMethodAdjustmentsToCreate": [], "shippingMethodAdjustmentIdsToRemove": []}, "compensateInput": {"computedPromotionCodes": [], "lineItemAdjustmentsToCreate": [], "lineItemAdjustmentIdsToRemove": [], "shippingMethodAdjustmentsToCreate": [], "shippingMethodAdjustmentIdsToRemove": []}}}}, "payload": {"cart_id": "cart_01K46AAXHDHBT18YFJSZZDTR33"}, "compensate": {}}, "errors": []}	done	2025-09-02 22:56:34.391	2025-09-02 22:56:34.478	\N	\N	01K46AAXGX5F9FC7KY368E20F2
wf_exec_01K46AR69CNDKFYH2QDCN67PWB	update-cart-promotions	update-cart-promotions-as-step-auto-01K46AR6768BTA04KKVA838BVN	{"runId": "01K46AR67CFS1TB24GMHCY6YYJ", "state": "done", "steps": {"_root": {"id": "_root", "next": ["_root.use-remote-query"]}, "_root.use-remote-query": {"id": "_root.use-remote-query", "next": ["_root.use-remote-query.validate"], "uuid": "01K469C7MZRTB0J3E7K3J0NKVN", "depth": 1, "invoke": {"state": "done", "status": "ok"}, "attempts": 1, "failures": 0, "startedAt": 1756854229302, "compensate": {"state": "dormant", "status": "idle"}, "definition": {"uuid": "01K469C7MZRTB0J3E7K3J0NKVN", "action": "use-remote-query", "noCompensation": true}, "stepFailed": false, "lastAttempt": 1756854229302, "saveResponse": true}, "_root.use-remote-query.validate": {"id": "_root.use-remote-query.validate", "next": ["_root.use-remote-query.validate.get-promotion-codes-to-apply"], "uuid": "01K469C7MZZ7DZ9NJTQXHXQBKM", "depth": 2, "invoke": {"state": "done", "status": "ok"}, "attempts": 1, "failures": 0, "startedAt": 1756854229321, "compensate": {"state": "dormant", "status": "idle"}, "definition": {"uuid": "01K469C7MZZ7DZ9NJTQXHXQBKM", "action": "validate", "noCompensation": false}, "stepFailed": false, "lastAttempt": 1756854229321, "saveResponse": true}, "_root.use-remote-query.validate.get-promotion-codes-to-apply": {"id": "_root.use-remote-query.validate.get-promotion-codes-to-apply", "next": ["_root.use-remote-query.validate.get-promotion-codes-to-apply.get-actions-to-compute-from-promotions"], "uuid": "01K469C7MZZEZVY9PFRV35WWVP", "depth": 3, "invoke": {"state": "done", "status": "ok"}, "attempts": 1, "failures": 0, "startedAt": 1756854229326, "compensate": {"state": "dormant", "status": "idle"}, "definition": {"uuid": "01K469C7MZZEZVY9PFRV35WWVP", "action": "get-promotion-codes-to-apply", "noCompensation": true}, "stepFailed": false, "lastAttempt": 1756854229326, "saveResponse": true}, "_root.use-remote-query.validate.get-promotion-codes-to-apply.get-actions-to-compute-from-promotions": {"id": "_root.use-remote-query.validate.get-promotion-codes-to-apply.get-actions-to-compute-from-promotions", "next": ["_root.use-remote-query.validate.get-promotion-codes-to-apply.get-actions-to-compute-from-promotions.prepare-adjustments-from-promotion-actions"], "uuid": "01K469C7MZ230XVA7CPQMNBBZK", "depth": 4, "invoke": {"state": "done", "status": "ok"}, "attempts": 1, "failures": 0, "startedAt": 1756854229332, "compensate": {"state": "dormant", "status": "idle"}, "definition": {"uuid": "01K469C7MZ230XVA7CPQMNBBZK", "action": "get-actions-to-compute-from-promotions", "noCompensation": true}, "stepFailed": false, "lastAttempt": 1756854229332, "saveResponse": true}, "_root.use-remote-query.validate.get-promotion-codes-to-apply.get-actions-to-compute-from-promotions.prepare-adjustments-from-promotion-actions": {"id": "_root.use-remote-query.validate.get-promotion-codes-to-apply.get-actions-to-compute-from-promotions.prepare-adjustments-from-promotion-actions", "next": ["_root.use-remote-query.validate.get-promotion-codes-to-apply.get-actions-to-compute-from-promotions.prepare-adjustments-from-promotion-actions.remove-line-item-adjustments", "_root.use-remote-query.validate.get-promotion-codes-to-apply.get-actions-to-compute-from-promotions.prepare-adjustments-from-promotion-actions.remove-shipping-method-adjustments", "_root.use-remote-query.validate.get-promotion-codes-to-apply.get-actions-to-compute-from-promotions.prepare-adjustments-from-promotion-actions.create-line-item-adjustments", "_root.use-remote-query.validate.get-promotion-codes-to-apply.get-actions-to-compute-from-promotions.prepare-adjustments-from-promotion-actions.create-shipping-method-adjustments", "_root.use-remote-query.validate.get-promotion-codes-to-apply.get-actions-to-compute-from-promotions.prepare-adjustments-from-promotion-actions.update-cart-promotions"], "uuid": "01K469C7MZP1FZ49MXK5KS5WE8", "depth": 5, "invoke": {"state": "done", "status": "ok"}, "attempts": 1, "failures": 0, "startedAt": 1756854229348, "compensate": {"state": "dormant", "status": "idle"}, "definition": {"uuid": "01K469C7MZP1FZ49MXK5KS5WE8", "action": "prepare-adjustments-from-promotion-actions", "noCompensation": true}, "stepFailed": false, "lastAttempt": 1756854229348, "saveResponse": true}, "_root.use-remote-query.validate.get-promotion-codes-to-apply.get-actions-to-compute-from-promotions.prepare-adjustments-from-promotion-actions.update-cart-promotions": {"id": "_root.use-remote-query.validate.get-promotion-codes-to-apply.get-actions-to-compute-from-promotions.prepare-adjustments-from-promotion-actions.update-cart-promotions", "next": [], "uuid": "01K469C7MZJGSJ03P98Z1WX96N", "depth": 6, "invoke": {"state": "done", "status": "ok"}, "attempts": 1, "failures": 0, "startedAt": 1756854229353, "compensate": {"state": "dormant", "status": "idle"}, "definition": {"uuid": "01K469C7MZJGSJ03P98Z1WX96N", "action": "update-cart-promotions", "noCompensation": false}, "stepFailed": false, "lastAttempt": 1756854229353, "saveResponse": true}, "_root.use-remote-query.validate.get-promotion-codes-to-apply.get-actions-to-compute-from-promotions.prepare-adjustments-from-promotion-actions.create-line-item-adjustments": {"id": "_root.use-remote-query.validate.get-promotion-codes-to-apply.get-actions-to-compute-from-promotions.prepare-adjustments-from-promotion-actions.create-line-item-adjustments", "next": [], "uuid": "01K469C7MZXZCWKF2H3VYG92D9", "depth": 6, "invoke": {"state": "done", "status": "ok"}, "attempts": 1, "failures": 0, "startedAt": 1756854229353, "compensate": {"state": "dormant", "status": "idle"}, "definition": {"uuid": "01K469C7MZXZCWKF2H3VYG92D9", "action": "create-line-item-adjustments", "noCompensation": false}, "stepFailed": false, "lastAttempt": 1756854229353, "saveResponse": true}, "_root.use-remote-query.validate.get-promotion-codes-to-apply.get-actions-to-compute-from-promotions.prepare-adjustments-from-promotion-actions.remove-line-item-adjustments": {"id": "_root.use-remote-query.validate.get-promotion-codes-to-apply.get-actions-to-compute-from-promotions.prepare-adjustments-from-promotion-actions.remove-line-item-adjustments", "next": [], "uuid": "01K469C7MZVTP07XXFPT7GTEAN", "depth": 6, "invoke": {"state": "done", "status": "ok"}, "attempts": 1, "failures": 0, "startedAt": 1756854229353, "compensate": {"state": "dormant", "status": "idle"}, "definition": {"uuid": "01K469C7MZVTP07XXFPT7GTEAN", "action": "remove-line-item-adjustments", "noCompensation": false}, "stepFailed": false, "lastAttempt": 1756854229353, "saveResponse": true}, "_root.use-remote-query.validate.get-promotion-codes-to-apply.get-actions-to-compute-from-promotions.prepare-adjustments-from-promotion-actions.create-shipping-method-adjustments": {"id": "_root.use-remote-query.validate.get-promotion-codes-to-apply.get-actions-to-compute-from-promotions.prepare-adjustments-from-promotion-actions.create-shipping-method-adjustments", "next": [], "uuid": "01K469C7MZBETCGP1B1XFG2GAH", "depth": 6, "invoke": {"state": "done", "status": "ok"}, "attempts": 1, "failures": 0, "startedAt": 1756854229353, "compensate": {"state": "dormant", "status": "idle"}, "definition": {"uuid": "01K469C7MZBETCGP1B1XFG2GAH", "action": "create-shipping-method-adjustments", "noCompensation": false}, "stepFailed": false, "lastAttempt": 1756854229353, "saveResponse": true}, "_root.use-remote-query.validate.get-promotion-codes-to-apply.get-actions-to-compute-from-promotions.prepare-adjustments-from-promotion-actions.remove-shipping-method-adjustments": {"id": "_root.use-remote-query.validate.get-promotion-codes-to-apply.get-actions-to-compute-from-promotions.prepare-adjustments-from-promotion-actions.remove-shipping-method-adjustments", "next": [], "uuid": "01K469C7MZH7W9A6EVXK2SEVDY", "depth": 6, "invoke": {"state": "done", "status": "ok"}, "attempts": 1, "failures": 0, "startedAt": 1756854229353, "compensate": {"state": "dormant", "status": "idle"}, "definition": {"uuid": "01K469C7MZH7W9A6EVXK2SEVDY", "action": "remove-shipping-method-adjustments", "noCompensation": false}, "stepFailed": false, "lastAttempt": 1756854229353, "saveResponse": true}}, "modelId": "update-cart-promotions", "options": {"name": "update-cart-promotions", "store": true, "idempotent": true}, "metadata": {"sourcePath": "/Users/mukul/Documents/GitHub/pharmint-marketplace/backend/node_modules/@medusajs/core-flows/dist/cart/workflows/update-cart-promotions.js", "eventGroupId": "01K46AR676ACA710CD16HDC8Q9", "preventReleaseEvents": true, "parentStepIdempotencyKey": "create-cart:auto-01K46AR6768BTA04KKVA838BVN:update-cart-promotions-as-step:invoke"}, "startedAt": 1756854229297, "definition": {"next": {"next": {"next": {"next": {"next": [{"uuid": "01K469C7MZVTP07XXFPT7GTEAN", "action": "remove-line-item-adjustments", "noCompensation": false}, {"uuid": "01K469C7MZH7W9A6EVXK2SEVDY", "action": "remove-shipping-method-adjustments", "noCompensation": false}, {"uuid": "01K469C7MZXZCWKF2H3VYG92D9", "action": "create-line-item-adjustments", "noCompensation": false}, {"uuid": "01K469C7MZBETCGP1B1XFG2GAH", "action": "create-shipping-method-adjustments", "noCompensation": false}, {"uuid": "01K469C7MZJGSJ03P98Z1WX96N", "action": "update-cart-promotions", "noCompensation": false}], "uuid": "01K469C7MZP1FZ49MXK5KS5WE8", "action": "prepare-adjustments-from-promotion-actions", "noCompensation": true}, "uuid": "01K469C7MZ230XVA7CPQMNBBZK", "action": "get-actions-to-compute-from-promotions", "noCompensation": true}, "uuid": "01K469C7MZZEZVY9PFRV35WWVP", "action": "get-promotion-codes-to-apply", "noCompensation": true}, "uuid": "01K469C7MZZ7DZ9NJTQXHXQBKM", "action": "validate", "noCompensation": false}, "uuid": "01K469C7MZRTB0J3E7K3J0NKVN", "action": "use-remote-query", "noCompensation": true}, "timedOutAt": null, "hasAsyncSteps": false, "transactionId": "update-cart-promotions-as-step-auto-01K46AR6768BTA04KKVA838BVN", "hasFailedSteps": false, "hasSkippedSteps": false, "hasWaitingSteps": false, "hasRevertedSteps": false, "hasSkippedOnFailureSteps": false}	{"data": {"invoke": {"validate": {"__type": "Symbol(WorkflowWorkflowData)", "output": {"__type": "Symbol(WorkflowStepResponse)"}}, "use-remote-query": {"__type": "Symbol(WorkflowWorkflowData)", "output": {"__type": "Symbol(WorkflowStepResponse)", "output": {"id": "cart_01K46AR6866A7DP2JNHJTC0G5Y", "items": [], "total": 0, "region": {"id": "reg_01K465NWZBB589QBS334WRK4PF", "name": "Europe", "metadata": null, "created_at": "2025-09-02T21:35:11.341Z", "deleted_at": null, "updated_at": "2025-09-02T21:35:11.341Z", "currency_code": "eur", "automatic_taxes": true}, "customer": {"id": "cus_01K46A3BBP2PYVPB81ECAQ2CVM", "email": "mk24x7@gmail.com", "phone": "+448005251034", "groups": [], "metadata": null, "last_name": "Yadav", "created_at": "2025-09-02T22:52:26.358Z", "created_by": null, "deleted_at": null, "first_name": "Mukul", "updated_at": "2025-09-02T22:52:26.358Z", "has_account": true, "company_name": null}, "metadata": null, "subtotal": 0, "region_id": "reg_01K465NWZBB589QBS334WRK4PF", "item_total": 0, "promotions": [], "customer_id": "cus_01K46A3BBP2PYVPB81ECAQ2CVM", "completed_at": null, "currency_code": "eur", "item_subtotal": 0, "sales_channel_id": "sc_01K465NVAAFMSJ0RGP5VCKEPVH", "shipping_methods": [], "shipping_subtotal": 0}, "compensateInput": {"id": "cart_01K46AR6866A7DP2JNHJTC0G5Y", "items": [], "total": 0, "region": {"id": "reg_01K465NWZBB589QBS334WRK4PF", "name": "Europe", "metadata": null, "created_at": "2025-09-02T21:35:11.341Z", "deleted_at": null, "updated_at": "2025-09-02T21:35:11.341Z", "currency_code": "eur", "automatic_taxes": true}, "customer": {"id": "cus_01K46A3BBP2PYVPB81ECAQ2CVM", "email": "mk24x7@gmail.com", "phone": "+448005251034", "groups": [], "metadata": null, "last_name": "Yadav", "created_at": "2025-09-02T22:52:26.358Z", "created_by": null, "deleted_at": null, "first_name": "Mukul", "updated_at": "2025-09-02T22:52:26.358Z", "has_account": true, "company_name": null}, "metadata": null, "subtotal": 0, "region_id": "reg_01K465NWZBB589QBS334WRK4PF", "item_total": 0, "promotions": [], "customer_id": "cus_01K46A3BBP2PYVPB81ECAQ2CVM", "completed_at": null, "currency_code": "eur", "item_subtotal": 0, "sales_channel_id": "sc_01K465NVAAFMSJ0RGP5VCKEPVH", "shipping_methods": [], "shipping_subtotal": 0}}}, "update-cart-promotions": {"__type": "Symbol(WorkflowWorkflowData)", "output": {"__type": "Symbol(WorkflowStepResponse)", "output": null, "compensateInput": {"createdLinkIds": [], "dismissedLinks": []}}}, "create-line-item-adjustments": {"__type": "Symbol(WorkflowWorkflowData)", "output": {"__type": "Symbol(WorkflowStepResponse)", "output": [], "compensateInput": []}}, "get-promotion-codes-to-apply": {"__type": "Symbol(WorkflowWorkflowData)", "output": {"__type": "Symbol(WorkflowStepResponse)", "output": [], "compensateInput": []}}, "remove-line-item-adjustments": {"__type": "Symbol(WorkflowWorkflowData)", "output": {"__type": "Symbol(WorkflowStepResponse)", "compensateInput": []}}, "create-shipping-method-adjustments": {"__type": "Symbol(WorkflowWorkflowData)", "output": {"__type": "Symbol(WorkflowStepResponse)", "compensateInput": []}}, "remove-shipping-method-adjustments": {"__type": "Symbol(WorkflowWorkflowData)", "output": {"__type": "Symbol(WorkflowStepResponse)", "compensateInput": []}}, "get-actions-to-compute-from-promotions": {"__type": "Symbol(WorkflowWorkflowData)", "output": {"__type": "Symbol(WorkflowStepResponse)", "output": [], "compensateInput": []}}, "prepare-adjustments-from-promotion-actions": {"__type": "Symbol(WorkflowWorkflowData)", "output": {"__type": "Symbol(WorkflowStepResponse)", "output": {"computedPromotionCodes": [], "lineItemAdjustmentsToCreate": [], "lineItemAdjustmentIdsToRemove": [], "shippingMethodAdjustmentsToCreate": [], "shippingMethodAdjustmentIdsToRemove": []}, "compensateInput": {"computedPromotionCodes": [], "lineItemAdjustmentsToCreate": [], "lineItemAdjustmentIdsToRemove": [], "shippingMethodAdjustmentsToCreate": [], "shippingMethodAdjustmentIdsToRemove": []}}}}, "payload": {"cart_id": "cart_01K46AR6866A7DP2JNHJTC0G5Y"}, "compensate": {}}, "errors": []}	done	2025-09-02 23:03:49.292	2025-09-02 23:03:49.366	\N	\N	01K46AR67CFS1TB24GMHCY6YYJ
wf_exec_01K46AAXNKZPGWX04EF6MB7RGJ	refresh-payment-collection-for-cart	refresh-payment-collection-for-cart-as-step-auto-01K46AAXGME6SGPZN47WAWQPXX	{"runId": "01K46AAXGX5F9FC7KY368E20F2", "state": "done", "steps": {"_root": {"id": "_root", "next": ["_root.use-remote-query"]}, "_root.use-remote-query": {"id": "_root.use-remote-query", "next": ["_root.use-remote-query.validate"], "uuid": "01K469C7MYE6F5K2A9J8T5ANE7", "depth": 1, "invoke": {"state": "done", "status": "ok"}, "attempts": 1, "failures": 0, "startedAt": 1756853794487, "compensate": {"state": "dormant", "status": "idle"}, "definition": {"uuid": "01K469C7MYE6F5K2A9J8T5ANE7", "action": "use-remote-query", "noCompensation": true}, "stepFailed": false, "lastAttempt": 1756853794487, "saveResponse": true}, "_root.use-remote-query.validate": {"id": "_root.use-remote-query.validate", "next": ["_root.use-remote-query.validate.delete-payment-sessions-as-step", "_root.use-remote-query.validate.update-payment-collection"], "uuid": "01K469C7MYP3P45ZM4P72S2XKS", "depth": 2, "invoke": {"state": "done", "status": "ok"}, "attempts": 1, "failures": 0, "startedAt": 1756853794499, "compensate": {"state": "dormant", "status": "idle"}, "definition": {"uuid": "01K469C7MYP3P45ZM4P72S2XKS", "action": "validate", "noCompensation": false}, "stepFailed": false, "lastAttempt": 1756853794499, "saveResponse": true}, "_root.use-remote-query.validate.update-payment-collection": {"id": "_root.use-remote-query.validate.update-payment-collection", "next": [], "uuid": "01K469C7MYBEYF34R5J2GCFD10", "depth": 3, "invoke": {"state": "done", "status": "ok"}, "attempts": 1, "failures": 0, "startedAt": 1756853794501, "compensate": {"state": "dormant", "status": "idle"}, "definition": {"uuid": "01K469C7MYBEYF34R5J2GCFD10", "action": "update-payment-collection", "noCompensation": false}, "stepFailed": false, "lastAttempt": 1756853794501, "saveResponse": true}, "_root.use-remote-query.validate.delete-payment-sessions-as-step": {"id": "_root.use-remote-query.validate.delete-payment-sessions-as-step", "next": [], "uuid": "01K469C7MYJ7W7X0X2VZ7HA3V2", "depth": 3, "invoke": {"state": "done", "status": "ok"}, "attempts": 1, "failures": 0, "startedAt": 1756853794501, "compensate": {"state": "dormant", "status": "idle"}, "definition": {"name": "delete-payment-sessions-as-step", "uuid": "01K469C7MYJ7W7X0X2VZ7HA3V2", "async": false, "action": "delete-payment-sessions-as-step", "nested": false, "noCompensation": false}, "stepFailed": false, "lastAttempt": 1756853794501, "saveResponse": true}}, "modelId": "refresh-payment-collection-for-cart", "options": {"name": "refresh-payment-collection-for-cart", "store": true, "idempotent": true}, "metadata": {"sourcePath": "/Users/mukul/Documents/GitHub/pharmint-marketplace/backend/node_modules/@medusajs/core-flows/dist/cart/workflows/refresh-payment-collection.js", "eventGroupId": "01K46AAXGMPJJDPCHR5ZPHJ132", "preventReleaseEvents": true, "parentStepIdempotencyKey": "create-cart:auto-01K46AAXGME6SGPZN47WAWQPXX:refresh-payment-collection-for-cart-as-step:invoke"}, "startedAt": 1756853794484, "definition": {"next": {"next": [{"name": "delete-payment-sessions-as-step", "uuid": "01K469C7MYJ7W7X0X2VZ7HA3V2", "async": false, "action": "delete-payment-sessions-as-step", "nested": false, "noCompensation": false}, {"uuid": "01K469C7MYBEYF34R5J2GCFD10", "action": "update-payment-collection", "noCompensation": false}], "uuid": "01K469C7MYP3P45ZM4P72S2XKS", "action": "validate", "noCompensation": false}, "uuid": "01K469C7MYE6F5K2A9J8T5ANE7", "action": "use-remote-query", "noCompensation": true}, "timedOutAt": null, "hasAsyncSteps": false, "transactionId": "refresh-payment-collection-for-cart-as-step-auto-01K46AAXGME6SGPZN47WAWQPXX", "hasFailedSteps": false, "hasSkippedSteps": false, "hasWaitingSteps": false, "hasRevertedSteps": false, "hasSkippedOnFailureSteps": false}	{"data": {"invoke": {"validate": {"__type": "Symbol(WorkflowWorkflowData)", "output": {"__type": "Symbol(WorkflowStepResponse)"}}, "use-remote-query": {"__type": "Symbol(WorkflowWorkflowData)", "output": {"__type": "Symbol(WorkflowStepResponse)", "output": {"id": "cart_01K46AAXHDHBT18YFJSZZDTR33", "total": 0, "raw_total": {"value": "0", "precision": 20}, "region_id": "reg_01K465NWZBB589QBS334WRK4PF", "currency_code": "eur"}, "compensateInput": {"id": "cart_01K46AAXHDHBT18YFJSZZDTR33", "total": 0, "raw_total": {"value": "0", "precision": 20}, "region_id": "reg_01K465NWZBB589QBS334WRK4PF", "currency_code": "eur"}}}, "update-payment-collection": {"__type": "Symbol(WorkflowWorkflowData)", "output": {"__type": "Symbol(WorkflowStepResponse)", "output": [], "compensateInput": []}}, "delete-payment-sessions-as-step": {"__type": "Symbol(WorkflowWorkflowData)", "output": {"__type": "Symbol(WorkflowStepResponse)", "output": [], "compensateInput": {"errors": [], "result": [], "thrownError": null, "transaction": {"flow": {"runId": "01K46AAXGX5F9FC7KY368E20F2", "state": "done", "steps": {"_root": {"id": "_root", "next": ["_root.delete-payment-sessions"]}, "_root.delete-payment-sessions": {"id": "_root.delete-payment-sessions", "next": ["_root.delete-payment-sessions.validate-deleted-payment-sessions"], "uuid": "01K469C7MW8WCT5KNWMBT8NWF4", "depth": 1, "invoke": {"state": "done", "status": "ok"}, "attempts": 1, "failures": 0, "startedAt": 1756853794504, "compensate": {"state": "dormant", "status": "idle"}, "definition": {"uuid": "01K469C7MW8WCT5KNWMBT8NWF4", "action": "delete-payment-sessions", "noCompensation": false}, "stepFailed": false, "lastAttempt": 1756853794504, "saveResponse": true}, "_root.delete-payment-sessions.validate-deleted-payment-sessions": {"id": "_root.delete-payment-sessions.validate-deleted-payment-sessions", "next": [], "uuid": "01K469C7MWVT1ZWZRD399W09VN", "depth": 2, "invoke": {"state": "done", "status": "ok"}, "attempts": 1, "failures": 0, "startedAt": 1756853794504, "compensate": {"state": "dormant", "status": "idle"}, "definition": {"uuid": "01K469C7MWVT1ZWZRD399W09VN", "action": "validate-deleted-payment-sessions", "noCompensation": true}, "stepFailed": false, "lastAttempt": 1756853794504, "saveResponse": true}}, "modelId": "delete-payment-sessions", "options": {}, "metadata": {"sourcePath": "/Users/mukul/Documents/GitHub/pharmint-marketplace/backend/node_modules/@medusajs/core-flows/dist/payment-collection/workflows/delete-payment-sessions.js", "eventGroupId": "01K46AAXGMPJJDPCHR5ZPHJ132", "preventReleaseEvents": true, "parentStepIdempotencyKey": "refresh-payment-collection-for-cart:refresh-payment-collection-for-cart-as-step-auto-01K46AAXGME6SGPZN47WAWQPXX:delete-payment-sessions-as-step:invoke"}, "startedAt": 1756853794504, "definition": {"next": {"uuid": "01K469C7MWVT1ZWZRD399W09VN", "action": "validate-deleted-payment-sessions", "noCompensation": true}, "uuid": "01K469C7MW8WCT5KNWMBT8NWF4", "action": "delete-payment-sessions", "noCompensation": false}, "timedOutAt": null, "hasAsyncSteps": false, "transactionId": "delete-payment-sessions-as-step-refresh-payment-collection-for-cart-as-step-auto-01K46AAXGME6SGPZN47WAWQPXX", "hasFailedSteps": false, "hasSkippedSteps": false, "hasWaitingSteps": false, "hasRevertedSteps": false, "hasSkippedOnFailureSteps": false}, "runId": "01K46AAXGX5F9FC7KY368E20F2", "errors": [], "_events": {}, "context": {"invoke": {"delete-payment-sessions": {"__type": "Symbol(WorkflowWorkflowData)", "output": {"__type": "Symbol(WorkflowStepResponse)", "output": [], "compensateInput": null}}, "validate-deleted-payment-sessions": {"__type": "Symbol(WorkflowWorkflowData)", "output": {"__type": "Symbol(WorkflowStepResponse)"}}}, "payload": {"ids": []}, "compensate": {}}, "modelId": "delete-payment-sessions", "payload": {"ids": []}, "_eventsCount": 0, "transactionId": "delete-payment-sessions-as-step-refresh-payment-collection-for-cart-as-step-auto-01K46AAXGME6SGPZN47WAWQPXX"}}}}}, "payload": {"cart_id": "cart_01K46AAXHDHBT18YFJSZZDTR33"}, "compensate": {}}, "errors": []}	done	2025-09-02 22:56:34.483	2025-09-02 22:56:34.507	\N	\N	01K46AAXGX5F9FC7KY368E20F2
wf_exec_01K46AR6BVEX7NVFZA5ATJ3SKS	refresh-payment-collection-for-cart	refresh-payment-collection-for-cart-as-step-auto-01K46AR6768BTA04KKVA838BVN	{"runId": "01K46AR67CFS1TB24GMHCY6YYJ", "state": "done", "steps": {"_root": {"id": "_root", "next": ["_root.use-remote-query"]}, "_root.use-remote-query": {"id": "_root.use-remote-query", "next": ["_root.use-remote-query.validate"], "uuid": "01K469C7MYE6F5K2A9J8T5ANE7", "depth": 1, "invoke": {"state": "done", "status": "ok"}, "attempts": 1, "failures": 0, "startedAt": 1756854229373, "compensate": {"state": "dormant", "status": "idle"}, "definition": {"uuid": "01K469C7MYE6F5K2A9J8T5ANE7", "action": "use-remote-query", "noCompensation": true}, "stepFailed": false, "lastAttempt": 1756854229373, "saveResponse": true}, "_root.use-remote-query.validate": {"id": "_root.use-remote-query.validate", "next": ["_root.use-remote-query.validate.delete-payment-sessions-as-step", "_root.use-remote-query.validate.update-payment-collection"], "uuid": "01K469C7MYP3P45ZM4P72S2XKS", "depth": 2, "invoke": {"state": "done", "status": "ok"}, "attempts": 1, "failures": 0, "startedAt": 1756854229383, "compensate": {"state": "dormant", "status": "idle"}, "definition": {"uuid": "01K469C7MYP3P45ZM4P72S2XKS", "action": "validate", "noCompensation": false}, "stepFailed": false, "lastAttempt": 1756854229383, "saveResponse": true}, "_root.use-remote-query.validate.update-payment-collection": {"id": "_root.use-remote-query.validate.update-payment-collection", "next": [], "uuid": "01K469C7MYBEYF34R5J2GCFD10", "depth": 3, "invoke": {"state": "done", "status": "ok"}, "attempts": 1, "failures": 0, "startedAt": 1756854229386, "compensate": {"state": "dormant", "status": "idle"}, "definition": {"uuid": "01K469C7MYBEYF34R5J2GCFD10", "action": "update-payment-collection", "noCompensation": false}, "stepFailed": false, "lastAttempt": 1756854229386, "saveResponse": true}, "_root.use-remote-query.validate.delete-payment-sessions-as-step": {"id": "_root.use-remote-query.validate.delete-payment-sessions-as-step", "next": [], "uuid": "01K469C7MYJ7W7X0X2VZ7HA3V2", "depth": 3, "invoke": {"state": "done", "status": "ok"}, "attempts": 1, "failures": 0, "startedAt": 1756854229386, "compensate": {"state": "dormant", "status": "idle"}, "definition": {"name": "delete-payment-sessions-as-step", "uuid": "01K469C7MYJ7W7X0X2VZ7HA3V2", "async": false, "action": "delete-payment-sessions-as-step", "nested": false, "noCompensation": false}, "stepFailed": false, "lastAttempt": 1756854229386, "saveResponse": true}}, "modelId": "refresh-payment-collection-for-cart", "options": {"name": "refresh-payment-collection-for-cart", "store": true, "idempotent": true}, "metadata": {"sourcePath": "/Users/mukul/Documents/GitHub/pharmint-marketplace/backend/node_modules/@medusajs/core-flows/dist/cart/workflows/refresh-payment-collection.js", "eventGroupId": "01K46AR676ACA710CD16HDC8Q9", "preventReleaseEvents": true, "parentStepIdempotencyKey": "create-cart:auto-01K46AR6768BTA04KKVA838BVN:refresh-payment-collection-for-cart-as-step:invoke"}, "startedAt": 1756854229372, "definition": {"next": {"next": [{"name": "delete-payment-sessions-as-step", "uuid": "01K469C7MYJ7W7X0X2VZ7HA3V2", "async": false, "action": "delete-payment-sessions-as-step", "nested": false, "noCompensation": false}, {"uuid": "01K469C7MYBEYF34R5J2GCFD10", "action": "update-payment-collection", "noCompensation": false}], "uuid": "01K469C7MYP3P45ZM4P72S2XKS", "action": "validate", "noCompensation": false}, "uuid": "01K469C7MYE6F5K2A9J8T5ANE7", "action": "use-remote-query", "noCompensation": true}, "timedOutAt": null, "hasAsyncSteps": false, "transactionId": "refresh-payment-collection-for-cart-as-step-auto-01K46AR6768BTA04KKVA838BVN", "hasFailedSteps": false, "hasSkippedSteps": false, "hasWaitingSteps": false, "hasRevertedSteps": false, "hasSkippedOnFailureSteps": false}	{"data": {"invoke": {"validate": {"__type": "Symbol(WorkflowWorkflowData)", "output": {"__type": "Symbol(WorkflowStepResponse)"}}, "use-remote-query": {"__type": "Symbol(WorkflowWorkflowData)", "output": {"__type": "Symbol(WorkflowStepResponse)", "output": {"id": "cart_01K46AR6866A7DP2JNHJTC0G5Y", "total": 0, "raw_total": {"value": "0", "precision": 20}, "region_id": "reg_01K465NWZBB589QBS334WRK4PF", "currency_code": "eur"}, "compensateInput": {"id": "cart_01K46AR6866A7DP2JNHJTC0G5Y", "total": 0, "raw_total": {"value": "0", "precision": 20}, "region_id": "reg_01K465NWZBB589QBS334WRK4PF", "currency_code": "eur"}}}, "update-payment-collection": {"__type": "Symbol(WorkflowWorkflowData)", "output": {"__type": "Symbol(WorkflowStepResponse)", "output": [], "compensateInput": []}}, "delete-payment-sessions-as-step": {"__type": "Symbol(WorkflowWorkflowData)", "output": {"__type": "Symbol(WorkflowStepResponse)", "output": [], "compensateInput": {"errors": [], "result": [], "thrownError": null, "transaction": {"flow": {"runId": "01K46AR67CFS1TB24GMHCY6YYJ", "state": "done", "steps": {"_root": {"id": "_root", "next": ["_root.delete-payment-sessions"]}, "_root.delete-payment-sessions": {"id": "_root.delete-payment-sessions", "next": ["_root.delete-payment-sessions.validate-deleted-payment-sessions"], "uuid": "01K469C7MW8WCT5KNWMBT8NWF4", "depth": 1, "invoke": {"state": "done", "status": "ok"}, "attempts": 1, "failures": 0, "startedAt": 1756854229389, "compensate": {"state": "dormant", "status": "idle"}, "definition": {"uuid": "01K469C7MW8WCT5KNWMBT8NWF4", "action": "delete-payment-sessions", "noCompensation": false}, "stepFailed": false, "lastAttempt": 1756854229389, "saveResponse": true}, "_root.delete-payment-sessions.validate-deleted-payment-sessions": {"id": "_root.delete-payment-sessions.validate-deleted-payment-sessions", "next": [], "uuid": "01K469C7MWVT1ZWZRD399W09VN", "depth": 2, "invoke": {"state": "done", "status": "ok"}, "attempts": 1, "failures": 0, "startedAt": 1756854229390, "compensate": {"state": "dormant", "status": "idle"}, "definition": {"uuid": "01K469C7MWVT1ZWZRD399W09VN", "action": "validate-deleted-payment-sessions", "noCompensation": true}, "stepFailed": false, "lastAttempt": 1756854229390, "saveResponse": true}}, "modelId": "delete-payment-sessions", "options": {}, "metadata": {"sourcePath": "/Users/mukul/Documents/GitHub/pharmint-marketplace/backend/node_modules/@medusajs/core-flows/dist/payment-collection/workflows/delete-payment-sessions.js", "eventGroupId": "01K46AR676ACA710CD16HDC8Q9", "preventReleaseEvents": true, "parentStepIdempotencyKey": "refresh-payment-collection-for-cart:refresh-payment-collection-for-cart-as-step-auto-01K46AR6768BTA04KKVA838BVN:delete-payment-sessions-as-step:invoke"}, "startedAt": 1756854229389, "definition": {"next": {"uuid": "01K469C7MWVT1ZWZRD399W09VN", "action": "validate-deleted-payment-sessions", "noCompensation": true}, "uuid": "01K469C7MW8WCT5KNWMBT8NWF4", "action": "delete-payment-sessions", "noCompensation": false}, "timedOutAt": null, "hasAsyncSteps": false, "transactionId": "delete-payment-sessions-as-step-refresh-payment-collection-for-cart-as-step-auto-01K46AR6768BTA04KKVA838BVN", "hasFailedSteps": false, "hasSkippedSteps": false, "hasWaitingSteps": false, "hasRevertedSteps": false, "hasSkippedOnFailureSteps": false}, "runId": "01K46AR67CFS1TB24GMHCY6YYJ", "errors": [], "_events": {}, "context": {"invoke": {"delete-payment-sessions": {"__type": "Symbol(WorkflowWorkflowData)", "output": {"__type": "Symbol(WorkflowStepResponse)", "output": [], "compensateInput": null}}, "validate-deleted-payment-sessions": {"__type": "Symbol(WorkflowWorkflowData)", "output": {"__type": "Symbol(WorkflowStepResponse)"}}}, "payload": {"ids": []}, "compensate": {}}, "modelId": "delete-payment-sessions", "payload": {"ids": []}, "_eventsCount": 0, "transactionId": "delete-payment-sessions-as-step-refresh-payment-collection-for-cart-as-step-auto-01K46AR6768BTA04KKVA838BVN"}}}}}, "payload": {"cart_id": "cart_01K46AR6866A7DP2JNHJTC0G5Y"}, "compensate": {}}, "errors": []}	done	2025-09-02 23:03:49.371	2025-09-02 23:03:49.395	\N	\N	01K46AR67CFS1TB24GMHCY6YYJ
wf_exec_01K46A1300BVQFJP8E09Z1Q6G7	refresh-cart-shipping-methods	refresh-cart-shipping-methods-as-step-refresh-cart-items-as-step-auto-01K46A12RDRJXRB1Y1TVQRHRSN	{"runId": "01K46A12RF3RVEMTWBR7A89T82", "state": "done", "steps": {"_root": {"id": "_root", "next": ["_root.get-cart"]}, "_root.get-cart": {"id": "_root.get-cart", "next": ["_root.get-cart.validate"], "uuid": "01K469C7MQCHMC23YZT1NTG73R", "depth": 1, "invoke": {"state": "skipped", "status": "ok"}, "attempts": 1, "failures": 0, "startedAt": 1756853472261, "compensate": {"state": "dormant", "status": "idle"}, "definition": {"uuid": "01K469C7MQCHMC23YZT1NTG73R", "async": false, "action": "get-cart", "noCompensation": true, "compensateAsync": false}, "stepFailed": false, "lastAttempt": 1756853472261, "saveResponse": true}, "_root.get-cart.validate": {"id": "_root.get-cart.validate", "next": ["_root.get-cart.validate.list-shipping-options-for-cart-with-pricing-as-step"], "uuid": "01K469C7MQMQBKT88Y31SGRCZV", "depth": 2, "invoke": {"state": "done", "status": "ok"}, "attempts": 1, "failures": 0, "startedAt": 1756853472267, "compensate": {"state": "dormant", "status": "idle"}, "definition": {"uuid": "01K469C7MQMQBKT88Y31SGRCZV", "action": "validate", "noCompensation": false}, "stepFailed": false, "lastAttempt": 1756853472267, "saveResponse": true}, "_root.get-cart.validate.list-shipping-options-for-cart-with-pricing-as-step": {"id": "_root.get-cart.validate.list-shipping-options-for-cart-with-pricing-as-step", "next": ["_root.get-cart.validate.list-shipping-options-for-cart-with-pricing-as-step.remove-shipping-method-to-cart-step", "_root.get-cart.validate.list-shipping-options-for-cart-with-pricing-as-step.update-shipping-methods-step"], "uuid": "01K469C7MQ9ZH8WP61QVYA9WGD", "depth": 3, "invoke": {"state": "done", "status": "ok"}, "attempts": 1, "failures": 0, "startedAt": 1756853472273, "compensate": {"state": "dormant", "status": "idle"}, "definition": {"name": "list-shipping-options-for-cart-with-pricing-as-step", "uuid": "01K469C7MQ9ZH8WP61QVYA9WGD", "async": false, "action": "list-shipping-options-for-cart-with-pricing-as-step", "nested": false, "noCompensation": false}, "stepFailed": false, "lastAttempt": 1756853472273, "saveResponse": true}, "_root.get-cart.validate.list-shipping-options-for-cart-with-pricing-as-step.update-shipping-methods-step": {"id": "_root.get-cart.validate.list-shipping-options-for-cart-with-pricing-as-step.update-shipping-methods-step", "next": [], "uuid": "01K469C7MQ2T7N5YP36F1GQ10Z", "depth": 4, "invoke": {"state": "done", "status": "ok"}, "attempts": 1, "failures": 0, "startedAt": 1756853472326, "compensate": {"state": "dormant", "status": "idle"}, "definition": {"uuid": "01K469C7MQ2T7N5YP36F1GQ10Z", "action": "update-shipping-methods-step", "noCompensation": false}, "stepFailed": false, "lastAttempt": 1756853472326, "saveResponse": true}, "_root.get-cart.validate.list-shipping-options-for-cart-with-pricing-as-step.remove-shipping-method-to-cart-step": {"id": "_root.get-cart.validate.list-shipping-options-for-cart-with-pricing-as-step.remove-shipping-method-to-cart-step", "next": [], "uuid": "01K469C7MQRZ9V334QTJ18V5ZX", "depth": 4, "invoke": {"state": "done", "status": "ok"}, "attempts": 1, "failures": 0, "startedAt": 1756853472326, "compensate": {"state": "dormant", "status": "idle"}, "definition": {"uuid": "01K469C7MQRZ9V334QTJ18V5ZX", "action": "remove-shipping-method-to-cart-step", "noCompensation": false}, "stepFailed": false, "lastAttempt": 1756853472326, "saveResponse": true}}, "modelId": "refresh-cart-shipping-methods", "options": {"name": "refresh-cart-shipping-methods", "store": true, "idempotent": true}, "metadata": {"sourcePath": "/Users/mukul/Documents/GitHub/pharmint-marketplace/backend/node_modules/@medusajs/core-flows/dist/cart/workflows/refresh-cart-shipping-methods.js", "eventGroupId": "01K46A12RD5DTAJW3P0DEHRKZB", "preventReleaseEvents": true, "parentStepIdempotencyKey": "refresh-cart-items:refresh-cart-items-as-step-auto-01K46A12RDRJXRB1Y1TVQRHRSN:refresh-cart-shipping-methods-as-step:invoke"}, "startedAt": 1756853472258, "definition": {"next": {"next": {"name": "list-shipping-options-for-cart-with-pricing-as-step", "next": [{"uuid": "01K469C7MQRZ9V334QTJ18V5ZX", "action": "remove-shipping-method-to-cart-step", "noCompensation": false}, {"uuid": "01K469C7MQ2T7N5YP36F1GQ10Z", "action": "update-shipping-methods-step", "noCompensation": false}], "uuid": "01K469C7MQ9ZH8WP61QVYA9WGD", "async": false, "action": "list-shipping-options-for-cart-with-pricing-as-step", "nested": false, "noCompensation": false}, "uuid": "01K469C7MQMQBKT88Y31SGRCZV", "action": "validate", "noCompensation": false}, "uuid": "01K469C7MQCHMC23YZT1NTG73R", "async": false, "action": "get-cart", "noCompensation": true, "compensateAsync": false}, "timedOutAt": null, "hasAsyncSteps": false, "transactionId": "refresh-cart-shipping-methods-as-step-refresh-cart-items-as-step-auto-01K46A12RDRJXRB1Y1TVQRHRSN", "hasFailedSteps": false, "hasSkippedSteps": true, "hasWaitingSteps": false, "hasRevertedSteps": false, "hasSkippedOnFailureSteps": false}	{"data": {"invoke": {"validate": {"__type": "Symbol(WorkflowWorkflowData)", "output": {"__type": "Symbol(WorkflowStepResponse)"}}, "update-shipping-methods-step": {"__type": "Symbol(WorkflowWorkflowData)", "output": {"__type": "Symbol(WorkflowStepResponse)", "output": [{"id": "casm_01K46A12WMTEF0WW2GPAESHJ3N", "cart": {"id": "cart_01K466AXHFNSF95BC7REXFZ8B0"}, "data": {}, "name": "Standard Shipping", "amount": 10, "cart_id": "cart_01K466AXHFNSF95BC7REXFZ8B0", "metadata": null, "created_at": "2025-09-02T22:51:12.148Z", "deleted_at": null, "raw_amount": {"value": "10", "precision": 20}, "updated_at": "2025-09-02T22:51:12.148Z", "description": null, "is_tax_inclusive": false, "shipping_option_id": "so_01K465NX0W8FHES8P37CAFHZS3"}], "compensateInput": [{"id": "casm_01K46A12WMTEF0WW2GPAESHJ3N", "amount": 10, "raw_amount": {"value": "10", "precision": 20}, "is_tax_inclusive": false, "shipping_option_id": "so_01K465NX0W8FHES8P37CAFHZS3"}]}}, "remove-shipping-method-to-cart-step": {"__type": "Symbol(WorkflowWorkflowData)", "output": {"__type": "Symbol(WorkflowStepResponse)", "output": null, "compensateInput": []}}, "list-shipping-options-for-cart-with-pricing-as-step": {"__type": "Symbol(WorkflowWorkflowData)", "output": {"__type": "Symbol(WorkflowStepResponse)", "output": [{"id": "so_01K465NX0W8FHES8P37CAFHZS3", "data": null, "name": "Standard Shipping", "type": {"id": "sotype_01K465NX0WGE47H7NC6TPMQ1VT", "code": "standard", "label": "Standard", "description": "Ship in 2-3 days."}, "rules": [{"value": "true", "operator": "eq", "attribute": "enabled_in_store"}, {"value": "false", "operator": "eq", "attribute": "is_return"}], "amount": 10, "prices": [{"id": "price_01K465NX13YV0869BSEMPE88P6", "title": null, "amount": 10, "created_at": "2025-09-02T21:35:11.396Z", "deleted_at": null, "price_list": null, "raw_amount": {"value": "10", "precision": 20}, "updated_at": "2025-09-02T21:35:11.396Z", "price_rules": [], "rules_count": 0, "max_quantity": null, "min_quantity": null, "price_set_id": "pset_01K465NX13CASJ8S3MJ3RY8NN0", "currency_code": "eur", "price_list_id": null}, {"id": "price_01K465NX13NW3SRA7AEEZVFP07", "title": null, "amount": 10, "created_at": "2025-09-02T21:35:11.396Z", "deleted_at": null, "price_list": null, "raw_amount": {"value": "10", "precision": 20}, "updated_at": "2025-09-02T21:35:11.396Z", "price_rules": [{"id": "prule_01K465NX13952QNKKADD38EZ3D", "value": "reg_01K465NWZBB589QBS334WRK4PF", "operator": "eq", "price_id": "price_01K465NX13NW3SRA7AEEZVFP07", "priority": 0, "attribute": "region_id", "created_at": "2025-09-02T21:35:11.396Z", "deleted_at": null, "updated_at": "2025-09-02T21:35:11.396Z"}], "rules_count": 1, "max_quantity": null, "min_quantity": null, "price_set_id": "pset_01K465NX13CASJ8S3MJ3RY8NN0", "currency_code": "eur", "price_list_id": null}, {"id": "price_01K465NX135PCBC1E9Q2P5KJ36", "title": null, "amount": 10, "created_at": "2025-09-02T21:35:11.396Z", "deleted_at": null, "price_list": null, "raw_amount": {"value": "10", "precision": 20}, "updated_at": "2025-09-02T21:35:11.396Z", "price_rules": [], "rules_count": 0, "max_quantity": null, "min_quantity": null, "price_set_id": "pset_01K465NX13CASJ8S3MJ3RY8NN0", "currency_code": "usd", "price_list_id": null}], "provider": {"id": "manual_manual", "is_enabled": true}, "price_type": "flat", "provider_id": "manual_manual", "service_zone": {"id": "serzo_01K465NX0B8X83QPDS4ZNJX86S", "fulfillment_set": {"id": "fuset_01K465NX0BS3XBXW4G9VJ79T0Z", "type": "shipping", "location": {"id": "sloc_01K465NX02PRA37GR065XPNVC1", "address": {"id": "laddr_01K465NX02JG26E8Z5N4C83M68", "city": "Copenhagen", "phone": null, "company": null, "metadata": null, "province": null, "address_1": "", "address_2": null, "created_at": "2025-09-02T21:35:11.362Z", "deleted_at": null, "updated_at": "2025-09-02T21:35:11.362Z", "postal_code": null, "country_code": "DK"}}}, "fulfillment_set_id": "fuset_01K465NX0BS3XBXW4G9VJ79T0Z"}, "service_zone_id": "serzo_01K465NX0B8X83QPDS4ZNJX86S", "calculated_price": {"id": "pset_01K465NX13CASJ8S3MJ3RY8NN0", "currency_code": "eur", "original_price": {"id": "price_01K465NX13NW3SRA7AEEZVFP07", "max_quantity": null, "min_quantity": null, "price_list_id": null, "price_list_type": null}, "original_amount": 10, "calculated_price": {"id": "price_01K465NX13NW3SRA7AEEZVFP07", "max_quantity": null, "min_quantity": null, "price_list_id": null, "price_list_type": null}, "calculated_amount": 10, "raw_original_amount": {"value": "10", "precision": 20}, "raw_calculated_amount": {"value": "10", "precision": 20}, "is_original_price_price_list": false, "is_calculated_price_price_list": false, "is_original_price_tax_inclusive": false, "is_calculated_price_tax_inclusive": false}, "is_tax_inclusive": false, "shipping_profile_id": "sp_01K465NSMNCMB3KTQC20148JAW"}], "compensateInput": {"errors": [], "result": [{"id": "so_01K465NX0W8FHES8P37CAFHZS3", "data": null, "name": "Standard Shipping", "type": {"id": "sotype_01K465NX0WGE47H7NC6TPMQ1VT", "code": "standard", "label": "Standard", "description": "Ship in 2-3 days."}, "rules": [{"value": "true", "operator": "eq", "attribute": "enabled_in_store"}, {"value": "false", "operator": "eq", "attribute": "is_return"}], "amount": 10, "prices": [{"id": "price_01K465NX13YV0869BSEMPE88P6", "title": null, "amount": 10, "created_at": "2025-09-02T21:35:11.396Z", "deleted_at": null, "price_list": null, "raw_amount": {"value": "10", "precision": 20}, "updated_at": "2025-09-02T21:35:11.396Z", "price_rules": [], "rules_count": 0, "max_quantity": null, "min_quantity": null, "price_set_id": "pset_01K465NX13CASJ8S3MJ3RY8NN0", "currency_code": "eur", "price_list_id": null}, {"id": "price_01K465NX13NW3SRA7AEEZVFP07", "title": null, "amount": 10, "created_at": "2025-09-02T21:35:11.396Z", "deleted_at": null, "price_list": null, "raw_amount": {"value": "10", "precision": 20}, "updated_at": "2025-09-02T21:35:11.396Z", "price_rules": [{"id": "prule_01K465NX13952QNKKADD38EZ3D", "value": "reg_01K465NWZBB589QBS334WRK4PF", "operator": "eq", "price_id": "price_01K465NX13NW3SRA7AEEZVFP07", "priority": 0, "attribute": "region_id", "created_at": "2025-09-02T21:35:11.396Z", "deleted_at": null, "updated_at": "2025-09-02T21:35:11.396Z"}], "rules_count": 1, "max_quantity": null, "min_quantity": null, "price_set_id": "pset_01K465NX13CASJ8S3MJ3RY8NN0", "currency_code": "eur", "price_list_id": null}, {"id": "price_01K465NX135PCBC1E9Q2P5KJ36", "title": null, "amount": 10, "created_at": "2025-09-02T21:35:11.396Z", "deleted_at": null, "price_list": null, "raw_amount": {"value": "10", "precision": 20}, "updated_at": "2025-09-02T21:35:11.396Z", "price_rules": [], "rules_count": 0, "max_quantity": null, "min_quantity": null, "price_set_id": "pset_01K465NX13CASJ8S3MJ3RY8NN0", "currency_code": "usd", "price_list_id": null}], "provider": {"id": "manual_manual", "is_enabled": true}, "price_type": "flat", "provider_id": "manual_manual", "service_zone": {"id": "serzo_01K465NX0B8X83QPDS4ZNJX86S", "fulfillment_set": {"id": "fuset_01K465NX0BS3XBXW4G9VJ79T0Z", "type": "shipping", "location": {"id": "sloc_01K465NX02PRA37GR065XPNVC1", "address": {"id": "laddr_01K465NX02JG26E8Z5N4C83M68", "city": "Copenhagen", "phone": null, "company": null, "metadata": null, "province": null, "address_1": "", "address_2": null, "created_at": "2025-09-02T21:35:11.362Z", "deleted_at": null, "updated_at": "2025-09-02T21:35:11.362Z", "postal_code": null, "country_code": "DK"}}}, "fulfillment_set_id": "fuset_01K465NX0BS3XBXW4G9VJ79T0Z"}, "service_zone_id": "serzo_01K465NX0B8X83QPDS4ZNJX86S", "calculated_price": {"id": "pset_01K465NX13CASJ8S3MJ3RY8NN0", "currency_code": "eur", "original_price": {"id": "price_01K465NX13NW3SRA7AEEZVFP07", "max_quantity": null, "min_quantity": null, "price_list_id": null, "price_list_type": null}, "original_amount": 10, "calculated_price": {"id": "price_01K465NX13NW3SRA7AEEZVFP07", "max_quantity": null, "min_quantity": null, "price_list_id": null, "price_list_type": null}, "calculated_amount": 10, "raw_original_amount": {"value": "10", "precision": 20}, "raw_calculated_amount": {"value": "10", "precision": 20}, "is_original_price_price_list": false, "is_calculated_price_price_list": false, "is_original_price_tax_inclusive": false, "is_calculated_price_tax_inclusive": false}, "is_tax_inclusive": false, "shipping_profile_id": "sp_01K465NSMNCMB3KTQC20148JAW"}], "thrownError": null, "transaction": {"flow": {"runId": "01K46A12RF3RVEMTWBR7A89T82", "state": "done", "steps": {"_root": {"id": "_root", "next": ["_root.get-cart"]}, "_root.get-cart": {"id": "_root.get-cart", "next": ["_root.get-cart.validate-presence-of"], "uuid": "01K469C7MMC8FQ6EK6588BRY5K", "depth": 1, "invoke": {"state": "done", "status": "ok"}, "attempts": 1, "failures": 0, "startedAt": 1756853472276, "compensate": {"state": "dormant", "status": "idle"}, "definition": {"uuid": "01K469C7MMC8FQ6EK6588BRY5K", "async": false, "action": "get-cart", "noCompensation": true, "compensateAsync": false}, "stepFailed": false, "lastAttempt": 1756853472276, "saveResponse": true}, "_root.get-cart.validate-presence-of": {"id": "_root.get-cart.validate-presence-of", "next": ["_root.get-cart.validate-presence-of.sales_channels-fulfillment-query"], "uuid": "01K469C7MM5VN9033ECN4VGAHX", "depth": 2, "invoke": {"state": "done", "status": "ok"}, "attempts": 1, "failures": 0, "startedAt": 1756853472286, "compensate": {"state": "dormant", "status": "idle"}, "definition": {"uuid": "01K469C7MM5VN9033ECN4VGAHX", "action": "validate-presence-of", "noCompensation": true}, "stepFailed": false, "lastAttempt": 1756853472286, "saveResponse": true}, "_root.get-cart.validate-presence-of.sales_channels-fulfillment-query": {"id": "_root.get-cart.validate-presence-of.sales_channels-fulfillment-query", "next": ["_root.get-cart.validate-presence-of.sales_channels-fulfillment-query.shipping-options-price-type-query"], "uuid": "01K469C7MM4S9AS2P3PAAKJEP6", "depth": 3, "invoke": {"state": "done", "status": "ok"}, "attempts": 1, "failures": 0, "startedAt": 1756853472287, "compensate": {"state": "dormant", "status": "idle"}, "definition": {"uuid": "01K469C7MM4S9AS2P3PAAKJEP6", "async": false, "action": "sales_channels-fulfillment-query", "noCompensation": true, "compensateAsync": false}, "stepFailed": false, "lastAttempt": 1756853472287, "saveResponse": true}, "_root.get-cart.validate-presence-of.sales_channels-fulfillment-query.shipping-options-price-type-query": {"id": "_root.get-cart.validate-presence-of.sales_channels-fulfillment-query.shipping-options-price-type-query", "next": ["_root.get-cart.validate-presence-of.sales_channels-fulfillment-query.shipping-options-price-type-query.shipping-options-query-flat-rate", "_root.get-cart.validate-presence-of.sales_channels-fulfillment-query.shipping-options-price-type-query.shipping-options-query-calculated"], "uuid": "01K469C7MMX9DKGTWD36E117FX", "depth": 4, "invoke": {"state": "done", "status": "ok"}, "attempts": 1, "failures": 0, "startedAt": 1756853472291, "compensate": {"state": "dormant", "status": "idle"}, "definition": {"uuid": "01K469C7MMX9DKGTWD36E117FX", "async": false, "action": "shipping-options-price-type-query", "noCompensation": true, "compensateAsync": false}, "stepFailed": false, "lastAttempt": 1756853472291, "saveResponse": true}, "_root.get-cart.validate-presence-of.sales_channels-fulfillment-query.shipping-options-price-type-query.shipping-options-query-flat-rate": {"id": "_root.get-cart.validate-presence-of.sales_channels-fulfillment-query.shipping-options-price-type-query.shipping-options-query-flat-rate", "next": [], "uuid": "01K469C7MMM3Z966GCSASTBRBN", "depth": 5, "invoke": {"state": "done", "status": "ok"}, "attempts": 1, "failures": 0, "startedAt": 1756853472298, "compensate": {"state": "dormant", "status": "idle"}, "definition": {"uuid": "01K469C7MMM3Z966GCSASTBRBN", "async": false, "action": "shipping-options-query-flat-rate", "noCompensation": true, "compensateAsync": false}, "stepFailed": false, "lastAttempt": 1756853472298, "saveResponse": true}, "_root.get-cart.validate-presence-of.sales_channels-fulfillment-query.shipping-options-price-type-query.shipping-options-query-calculated": {"id": "_root.get-cart.validate-presence-of.sales_channels-fulfillment-query.shipping-options-price-type-query.shipping-options-query-calculated", "next": ["_root.get-cart.validate-presence-of.sales_channels-fulfillment-query.shipping-options-price-type-query.shipping-options-query-calculated.calculate-shipping-options-prices"], "uuid": "01K469C7MN76B2K37SE10V99X8", "depth": 5, "invoke": {"state": "done", "status": "ok"}, "attempts": 1, "failures": 0, "startedAt": 1756853472298, "compensate": {"state": "dormant", "status": "idle"}, "definition": {"uuid": "01K469C7MN76B2K37SE10V99X8", "async": false, "action": "shipping-options-query-calculated", "noCompensation": true, "compensateAsync": false}, "stepFailed": false, "lastAttempt": 1756853472298, "saveResponse": true}, "_root.get-cart.validate-presence-of.sales_channels-fulfillment-query.shipping-options-price-type-query.shipping-options-query-calculated.calculate-shipping-options-prices": {"id": "_root.get-cart.validate-presence-of.sales_channels-fulfillment-query.shipping-options-price-type-query.shipping-options-query-calculated.calculate-shipping-options-prices", "next": [], "uuid": "01K469C7MN9PREV9XC352WHDHS", "depth": 6, "invoke": {"state": "done", "status": "ok"}, "attempts": 1, "failures": 0, "startedAt": 1756853472318, "compensate": {"state": "dormant", "status": "idle"}, "definition": {"uuid": "01K469C7MN9PREV9XC352WHDHS", "action": "calculate-shipping-options-prices", "noCompensation": true}, "stepFailed": false, "lastAttempt": 1756853472318, "saveResponse": true}}, "modelId": "list-shipping-options-for-cart-with-pricing", "options": {}, "metadata": {"sourcePath": "/Users/mukul/Documents/GitHub/pharmint-marketplace/backend/node_modules/@medusajs/core-flows/dist/cart/workflows/list-shipping-options-for-cart-with-pricing.js", "eventGroupId": "01K46A12RD5DTAJW3P0DEHRKZB", "preventReleaseEvents": true, "parentStepIdempotencyKey": "refresh-cart-shipping-methods:refresh-cart-shipping-methods-as-step-refresh-cart-items-as-step-auto-01K46A12RDRJXRB1Y1TVQRHRSN:list-shipping-options-for-cart-with-pricing-as-step:invoke"}, "startedAt": 1756853472276, "definition": {"next": {"next": {"next": {"next": [{"uuid": "01K469C7MMM3Z966GCSASTBRBN", "async": false, "action": "shipping-options-query-flat-rate", "noCompensation": true, "compensateAsync": false}, {"next": {"uuid": "01K469C7MN9PREV9XC352WHDHS", "action": "calculate-shipping-options-prices", "noCompensation": true}, "uuid": "01K469C7MN76B2K37SE10V99X8", "async": false, "action": "shipping-options-query-calculated", "noCompensation": true, "compensateAsync": false}], "uuid": "01K469C7MMX9DKGTWD36E117FX", "async": false, "action": "shipping-options-price-type-query", "noCompensation": true, "compensateAsync": false}, "uuid": "01K469C7MM4S9AS2P3PAAKJEP6", "async": false, "action": "sales_channels-fulfillment-query", "noCompensation": true, "compensateAsync": false}, "uuid": "01K469C7MM5VN9033ECN4VGAHX", "action": "validate-presence-of", "noCompensation": true}, "uuid": "01K469C7MMC8FQ6EK6588BRY5K", "async": false, "action": "get-cart", "noCompensation": true, "compensateAsync": false}, "timedOutAt": null, "hasAsyncSteps": false, "transactionId": "list-shipping-options-for-cart-with-pricing-as-step-refresh-cart-shipping-methods-as-step-refresh-cart-items-as-step-auto-01K46A12RDRJXRB1Y1TVQRHRSN", "hasFailedSteps": false, "hasSkippedSteps": false, "hasWaitingSteps": false, "hasRevertedSteps": false, "hasSkippedOnFailureSteps": false}, "runId": "01K46A12RF3RVEMTWBR7A89T82", "errors": [], "_events": {}, "context": {"invoke": {"get-cart": {"__type": "Symbol(WorkflowWorkflowData)", "output": {"__type": "Symbol(WorkflowStepResponse)", "output": {"data": [{"id": "cart_01K466AXHFNSF95BC7REXFZ8B0", "items": [{"id": "cali_01K468ECQFE8SQKS9467B5AD66", "title": "Medusa T-Shirt", "total": 10, "cart_id": "cart_01K466AXHFNSF95BC7REXFZ8B0", "product": {"id": "prod_01K465NX26VFWW6C9Y3GJN3K6V", "tags": [], "categories": [], "collection_id": null}, "variant": {"id": "variant_01K465NX36QVW4VT9ZBR1WEYPA", "width": null, "height": null, "length": null, "weight": null, "product": {"id": "prod_01K465NX26VFWW6C9Y3GJN3K6V"}, "material": null, "product_id": "prod_01K465NX26VFWW6C9Y3GJN3K6V"}, "metadata": {}, "quantity": 1, "subtitle": "M / Black", "subtotal": 10, "raw_total": {"value": "10", "precision": 20}, "tax_lines": [], "tax_total": 0, "thumbnail": "https://medusa-public-images.s3.eu-west-1.amazonaws.com/tee-black-front.png", "created_at": "2025-09-02T22:23:31.055Z", "deleted_at": null, "product_id": "prod_01K465NX26VFWW6C9Y3GJN3K6V", "unit_price": 10, "updated_at": "2025-09-02T22:23:31.055Z", "variant_id": "variant_01K465NX36QVW4VT9ZBR1WEYPA", "adjustments": [], "is_giftcard": false, "variant_sku": "SHIRT-M-BLACK", "product_type": null, "raw_subtotal": {"value": "10", "precision": 20}, "product_title": "Medusa T-Shirt", "raw_tax_total": {"value": "0", "precision": 20}, "variant_title": "M / Black", "discount_total": 0, "original_total": 10, "product_handle": "t-shirt", "raw_unit_price": {"value": "10", "precision": 20}, "is_custom_price": false, "is_discountable": true, "product_type_id": null, "variant_barcode": null, "is_tax_inclusive": false, "product_subtitle": null, "discount_subtotal": 0, "requires_shipping": true, "discount_tax_total": 0, "original_tax_total": 0, "product_collection": null, "raw_discount_total": {"value": "0", "precision": 20}, "raw_original_total": {"value": "10", "precision": 20}, "product_description": "Reimagine the feeling of a classic T-shirt. With our cotton T-shirts, everyday essentials no longer have to be ordinary.", "compare_at_unit_price": null, "raw_discount_subtotal": {"value": "0", "precision": 20}, "variant_option_values": null, "raw_discount_tax_total": {"value": "0", "precision": 20}, "raw_original_tax_total": {"value": "0", "precision": 20}, "raw_compare_at_unit_price": null}], "total": 20, "region_id": "reg_01K465NWZBB589QBS334WRK4PF", "item_total": 10, "currency_code": "eur", "sales_channel_id": "sc_01K465NVAAFMSJ0RGP5VCKEPVH", "shipping_address": {"id": "caaddr_01K46A0ZRNPRJP2YKVVCX2RH5W", "city": "varanasi", "phone": "", "company": "", "metadata": null, "province": "up", "address_1": "test", "address_2": "", "last_name": "test", "created_at": "2025-09-02T22:51:08.950Z", "deleted_at": null, "first_name": "test", "updated_at": "2025-09-02T22:51:08.950Z", "customer_id": null, "postal_code": "221002", "country_code": "it"}}]}, "compensateInput": {"data": [{"id": "cart_01K466AXHFNSF95BC7REXFZ8B0", "items": [{"id": "cali_01K468ECQFE8SQKS9467B5AD66", "title": "Medusa T-Shirt", "total": 10, "cart_id": "cart_01K466AXHFNSF95BC7REXFZ8B0", "product": {"id": "prod_01K465NX26VFWW6C9Y3GJN3K6V", "tags": [], "categories": [], "collection_id": null}, "variant": {"id": "variant_01K465NX36QVW4VT9ZBR1WEYPA", "width": null, "height": null, "length": null, "weight": null, "product": {"id": "prod_01K465NX26VFWW6C9Y3GJN3K6V"}, "material": null, "product_id": "prod_01K465NX26VFWW6C9Y3GJN3K6V"}, "metadata": {}, "quantity": 1, "subtitle": "M / Black", "subtotal": 10, "raw_total": {"value": "10", "precision": 20}, "tax_lines": [], "tax_total": 0, "thumbnail": "https://medusa-public-images.s3.eu-west-1.amazonaws.com/tee-black-front.png", "created_at": "2025-09-02T22:23:31.055Z", "deleted_at": null, "product_id": "prod_01K465NX26VFWW6C9Y3GJN3K6V", "unit_price": 10, "updated_at": "2025-09-02T22:23:31.055Z", "variant_id": "variant_01K465NX36QVW4VT9ZBR1WEYPA", "adjustments": [], "is_giftcard": false, "variant_sku": "SHIRT-M-BLACK", "product_type": null, "raw_subtotal": {"value": "10", "precision": 20}, "product_title": "Medusa T-Shirt", "raw_tax_total": {"value": "0", "precision": 20}, "variant_title": "M / Black", "discount_total": 0, "original_total": 10, "product_handle": "t-shirt", "raw_unit_price": {"value": "10", "precision": 20}, "is_custom_price": false, "is_discountable": true, "product_type_id": null, "variant_barcode": null, "is_tax_inclusive": false, "product_subtitle": null, "discount_subtotal": 0, "requires_shipping": true, "discount_tax_total": 0, "original_tax_total": 0, "product_collection": null, "raw_discount_total": {"value": "0", "precision": 20}, "raw_original_total": {"value": "10", "precision": 20}, "product_description": "Reimagine the feeling of a classic T-shirt. With our cotton T-shirts, everyday essentials no longer have to be ordinary.", "compare_at_unit_price": null, "raw_discount_subtotal": {"value": "0", "precision": 20}, "variant_option_values": null, "raw_discount_tax_total": {"value": "0", "precision": 20}, "raw_original_tax_total": {"value": "0", "precision": 20}, "raw_compare_at_unit_price": null}], "total": 20, "region_id": "reg_01K465NWZBB589QBS334WRK4PF", "item_total": 10, "currency_code": "eur", "sales_channel_id": "sc_01K465NVAAFMSJ0RGP5VCKEPVH", "shipping_address": {"id": "caaddr_01K46A0ZRNPRJP2YKVVCX2RH5W", "city": "varanasi", "phone": "", "company": "", "metadata": null, "province": "up", "address_1": "test", "address_2": "", "last_name": "test", "created_at": "2025-09-02T22:51:08.950Z", "deleted_at": null, "first_name": "test", "updated_at": "2025-09-02T22:51:08.950Z", "customer_id": null, "postal_code": "221002", "country_code": "it"}}]}}}, "validate-presence-of": {"__type": "Symbol(WorkflowWorkflowData)"}, "sales_channels-fulfillment-query": {"__type": "Symbol(WorkflowWorkflowData)", "output": {"__type": "Symbol(WorkflowStepResponse)", "output": {"data": [{"id": "sc_01K465NVAAFMSJ0RGP5VCKEPVH", "stock_locations": [{"id": "sloc_01K465NX02PRA37GR065XPNVC1", "name": "European Warehouse", "address": {"id": "laddr_01K465NX02JG26E8Z5N4C83M68", "city": "Copenhagen", "phone": null, "company": null, "metadata": null, "province": null, "address_1": "", "address_2": null, "created_at": "2025-09-02T21:35:11.362Z", "deleted_at": null, "updated_at": "2025-09-02T21:35:11.362Z", "postal_code": null, "country_code": "DK"}, "fulfillment_sets": [{"id": "fuset_01K465NX0BS3XBXW4G9VJ79T0Z"}]}]}]}, "compensateInput": {"data": [{"id": "sc_01K465NVAAFMSJ0RGP5VCKEPVH", "stock_locations": [{"id": "sloc_01K465NX02PRA37GR065XPNVC1", "name": "European Warehouse", "address": {"id": "laddr_01K465NX02JG26E8Z5N4C83M68", "city": "Copenhagen", "phone": null, "company": null, "metadata": null, "province": null, "address_1": "", "address_2": null, "created_at": "2025-09-02T21:35:11.362Z", "deleted_at": null, "updated_at": "2025-09-02T21:35:11.362Z", "postal_code": null, "country_code": "DK"}, "fulfillment_sets": [{"id": "fuset_01K465NX0BS3XBXW4G9VJ79T0Z"}]}]}]}}}, "shipping-options-query-flat-rate": {"__type": "Symbol(WorkflowWorkflowData)", "output": {"__type": "Symbol(WorkflowStepResponse)", "output": [{"id": "so_01K465NX0W8FHES8P37CAFHZS3", "data": null, "name": "Standard Shipping", "type": {"id": "sotype_01K465NX0WGE47H7NC6TPMQ1VT", "code": "standard", "label": "Standard", "description": "Ship in 2-3 days."}, "rules": [{"value": "true", "operator": "eq", "attribute": "enabled_in_store"}, {"value": "false", "operator": "eq", "attribute": "is_return"}], "prices": [{"id": "price_01K465NX13YV0869BSEMPE88P6", "title": null, "amount": 10, "created_at": "2025-09-02T21:35:11.396Z", "deleted_at": null, "price_list": null, "raw_amount": {"value": "10", "precision": 20}, "updated_at": "2025-09-02T21:35:11.396Z", "price_rules": [], "rules_count": 0, "max_quantity": null, "min_quantity": null, "price_set_id": "pset_01K465NX13CASJ8S3MJ3RY8NN0", "currency_code": "eur", "price_list_id": null}, {"id": "price_01K465NX13NW3SRA7AEEZVFP07", "title": null, "amount": 10, "created_at": "2025-09-02T21:35:11.396Z", "deleted_at": null, "price_list": null, "raw_amount": {"value": "10", "precision": 20}, "updated_at": "2025-09-02T21:35:11.396Z", "price_rules": [{"id": "prule_01K465NX13952QNKKADD38EZ3D", "value": "reg_01K465NWZBB589QBS334WRK4PF", "operator": "eq", "price_id": "price_01K465NX13NW3SRA7AEEZVFP07", "priority": 0, "attribute": "region_id", "created_at": "2025-09-02T21:35:11.396Z", "deleted_at": null, "updated_at": "2025-09-02T21:35:11.396Z"}], "rules_count": 1, "max_quantity": null, "min_quantity": null, "price_set_id": "pset_01K465NX13CASJ8S3MJ3RY8NN0", "currency_code": "eur", "price_list_id": null}, {"id": "price_01K465NX135PCBC1E9Q2P5KJ36", "title": null, "amount": 10, "created_at": "2025-09-02T21:35:11.396Z", "deleted_at": null, "price_list": null, "raw_amount": {"value": "10", "precision": 20}, "updated_at": "2025-09-02T21:35:11.396Z", "price_rules": [], "rules_count": 0, "max_quantity": null, "min_quantity": null, "price_set_id": "pset_01K465NX13CASJ8S3MJ3RY8NN0", "currency_code": "usd", "price_list_id": null}], "provider": {"id": "manual_manual", "is_enabled": true}, "price_type": "flat", "provider_id": "manual_manual", "service_zone": {"id": "serzo_01K465NX0B8X83QPDS4ZNJX86S", "fulfillment_set": {"id": "fuset_01K465NX0BS3XBXW4G9VJ79T0Z", "type": "shipping", "location": {"id": "sloc_01K465NX02PRA37GR065XPNVC1", "address": {"id": "laddr_01K465NX02JG26E8Z5N4C83M68", "city": "Copenhagen", "phone": null, "company": null, "metadata": null, "province": null, "address_1": "", "address_2": null, "created_at": "2025-09-02T21:35:11.362Z", "deleted_at": null, "updated_at": "2025-09-02T21:35:11.362Z", "postal_code": null, "country_code": "DK"}}}, "fulfillment_set_id": "fuset_01K465NX0BS3XBXW4G9VJ79T0Z"}, "service_zone_id": "serzo_01K465NX0B8X83QPDS4ZNJX86S", "calculated_price": {"id": "pset_01K465NX13CASJ8S3MJ3RY8NN0", "currency_code": "eur", "original_price": {"id": "price_01K465NX13NW3SRA7AEEZVFP07", "max_quantity": null, "min_quantity": null, "price_list_id": null, "price_list_type": null}, "original_amount": 10, "calculated_price": {"id": "price_01K465NX13NW3SRA7AEEZVFP07", "max_quantity": null, "min_quantity": null, "price_list_id": null, "price_list_type": null}, "calculated_amount": 10, "raw_original_amount": {"value": "10", "precision": 20}, "raw_calculated_amount": {"value": "10", "precision": 20}, "is_original_price_price_list": false, "is_calculated_price_price_list": false, "is_original_price_tax_inclusive": false, "is_calculated_price_tax_inclusive": false}, "shipping_profile_id": "sp_01K465NSMNCMB3KTQC20148JAW"}], "compensateInput": [{"id": "so_01K465NX0W8FHES8P37CAFHZS3", "data": null, "name": "Standard Shipping", "type": {"id": "sotype_01K465NX0WGE47H7NC6TPMQ1VT", "code": "standard", "label": "Standard", "description": "Ship in 2-3 days."}, "rules": [{"value": "true", "operator": "eq", "attribute": "enabled_in_store"}, {"value": "false", "operator": "eq", "attribute": "is_return"}], "prices": [{"id": "price_01K465NX13YV0869BSEMPE88P6", "title": null, "amount": 10, "created_at": "2025-09-02T21:35:11.396Z", "deleted_at": null, "price_list": null, "raw_amount": {"value": "10", "precision": 20}, "updated_at": "2025-09-02T21:35:11.396Z", "price_rules": [], "rules_count": 0, "max_quantity": null, "min_quantity": null, "price_set_id": "pset_01K465NX13CASJ8S3MJ3RY8NN0", "currency_code": "eur", "price_list_id": null}, {"id": "price_01K465NX13NW3SRA7AEEZVFP07", "title": null, "amount": 10, "created_at": "2025-09-02T21:35:11.396Z", "deleted_at": null, "price_list": null, "raw_amount": {"value": "10", "precision": 20}, "updated_at": "2025-09-02T21:35:11.396Z", "price_rules": [{"id": "prule_01K465NX13952QNKKADD38EZ3D", "value": "reg_01K465NWZBB589QBS334WRK4PF", "operator": "eq", "price_id": "price_01K465NX13NW3SRA7AEEZVFP07", "priority": 0, "attribute": "region_id", "created_at": "2025-09-02T21:35:11.396Z", "deleted_at": null, "updated_at": "2025-09-02T21:35:11.396Z"}], "rules_count": 1, "max_quantity": null, "min_quantity": null, "price_set_id": "pset_01K465NX13CASJ8S3MJ3RY8NN0", "currency_code": "eur", "price_list_id": null}, {"id": "price_01K465NX135PCBC1E9Q2P5KJ36", "title": null, "amount": 10, "created_at": "2025-09-02T21:35:11.396Z", "deleted_at": null, "price_list": null, "raw_amount": {"value": "10", "precision": 20}, "updated_at": "2025-09-02T21:35:11.396Z", "price_rules": [], "rules_count": 0, "max_quantity": null, "min_quantity": null, "price_set_id": "pset_01K465NX13CASJ8S3MJ3RY8NN0", "currency_code": "usd", "price_list_id": null}], "provider": {"id": "manual_manual", "is_enabled": true}, "price_type": "flat", "provider_id": "manual_manual", "service_zone": {"id": "serzo_01K465NX0B8X83QPDS4ZNJX86S", "fulfillment_set": {"id": "fuset_01K465NX0BS3XBXW4G9VJ79T0Z", "type": "shipping", "location": {"id": "sloc_01K465NX02PRA37GR065XPNVC1", "address": {"id": "laddr_01K465NX02JG26E8Z5N4C83M68", "city": "Copenhagen", "phone": null, "company": null, "metadata": null, "province": null, "address_1": "", "address_2": null, "created_at": "2025-09-02T21:35:11.362Z", "deleted_at": null, "updated_at": "2025-09-02T21:35:11.362Z", "postal_code": null, "country_code": "DK"}}}, "fulfillment_set_id": "fuset_01K465NX0BS3XBXW4G9VJ79T0Z"}, "service_zone_id": "serzo_01K465NX0B8X83QPDS4ZNJX86S", "calculated_price": {"id": "pset_01K465NX13CASJ8S3MJ3RY8NN0", "currency_code": "eur", "original_price": {"id": "price_01K465NX13NW3SRA7AEEZVFP07", "max_quantity": null, "min_quantity": null, "price_list_id": null, "price_list_type": null}, "original_amount": 10, "calculated_price": {"id": "price_01K465NX13NW3SRA7AEEZVFP07", "max_quantity": null, "min_quantity": null, "price_list_id": null, "price_list_type": null}, "calculated_amount": 10, "raw_original_amount": {"value": "10", "precision": 20}, "raw_calculated_amount": {"value": "10", "precision": 20}, "is_original_price_price_list": false, "is_calculated_price_price_list": false, "is_original_price_tax_inclusive": false, "is_calculated_price_tax_inclusive": false}, "shipping_profile_id": "sp_01K465NSMNCMB3KTQC20148JAW"}]}}, "calculate-shipping-options-prices": {"__type": "Symbol(WorkflowWorkflowData)", "output": {"__type": "Symbol(WorkflowStepResponse)", "output": [], "compensateInput": []}}, "shipping-options-price-type-query": {"__type": "Symbol(WorkflowWorkflowData)", "output": {"__type": "Symbol(WorkflowStepResponse)", "output": [{"id": "so_01K465NX0W8FHES8P37CAFHZS3", "price_type": "flat"}], "compensateInput": [{"id": "so_01K465NX0W8FHES8P37CAFHZS3", "price_type": "flat"}]}}, "shipping-options-query-calculated": {"__type": "Symbol(WorkflowWorkflowData)", "output": {"__type": "Symbol(WorkflowStepResponse)", "output": [], "compensateInput": []}}}, "payload": {"cart_id": "cart_01K466AXHFNSF95BC7REXFZ8B0", "options": [{"id": "so_01K465NX0W8FHES8P37CAFHZS3", "data": {}}], "is_return": false}, "compensate": {}}, "modelId": "list-shipping-options-for-cart-with-pricing", "payload": {"cart_id": "cart_01K466AXHFNSF95BC7REXFZ8B0", "options": [{"id": "so_01K465NX0W8FHES8P37CAFHZS3", "data": {}}], "is_return": false}, "_eventsCount": 0, "transactionId": "list-shipping-options-for-cart-with-pricing-as-step-refresh-cart-shipping-methods-as-step-refresh-cart-items-as-step-auto-01K46A12RDRJXRB1Y1TVQRHRSN"}}}}}, "payload": {"cart": {"id": "cart_01K466AXHFNSF95BC7REXFZ8B0", "items": [{"id": "cali_01K468ECQFE8SQKS9467B5AD66", "title": "Medusa T-Shirt", "total": 10, "cart_id": "cart_01K466AXHFNSF95BC7REXFZ8B0", "product": {"id": "prod_01K465NX26VFWW6C9Y3GJN3K6V", "tags": [], "type_id": null, "categories": [], "is_giftcard": false, "collection_id": null}, "variant": {"id": "variant_01K465NX36QVW4VT9ZBR1WEYPA", "width": null, "height": null, "length": null, "weight": null, "product": {"id": "prod_01K465NX26VFWW6C9Y3GJN3K6V"}, "material": null, "product_id": "prod_01K465NX26VFWW6C9Y3GJN3K6V"}, "metadata": {}, "quantity": 1, "subtitle": "M / Black", "subtotal": 10, "raw_total": {"value": "10", "precision": 20}, "tax_lines": [], "tax_total": 0, "thumbnail": "https://medusa-public-images.s3.eu-west-1.amazonaws.com/tee-black-front.png", "created_at": "2025-09-02T22:23:31.055Z", "deleted_at": null, "product_id": "prod_01K465NX26VFWW6C9Y3GJN3K6V", "unit_price": 10, "updated_at": "2025-09-02T22:23:31.055Z", "variant_id": "variant_01K465NX36QVW4VT9ZBR1WEYPA", "adjustments": [], "is_giftcard": false, "variant_sku": "SHIRT-M-BLACK", "product_type": null, "raw_subtotal": {"value": "10", "precision": 20}, "product_title": "Medusa T-Shirt", "raw_tax_total": {"value": "0", "precision": 20}, "variant_title": "M / Black", "discount_total": 0, "original_total": 10, "product_handle": "t-shirt", "raw_unit_price": {"value": "10", "precision": 20}, "is_custom_price": false, "is_discountable": true, "product_type_id": null, "variant_barcode": null, "is_tax_inclusive": false, "product_subtitle": null, "discount_subtotal": 0, "requires_shipping": true, "discount_tax_total": 0, "original_tax_total": 0, "product_collection": null, "raw_discount_total": {"value": "0", "precision": 20}, "raw_original_total": {"value": "10", "precision": 20}, "product_description": "Reimagine the feeling of a classic T-shirt. With our cotton T-shirts, everyday essentials no longer have to be ordinary.", "compare_at_unit_price": null, "raw_discount_subtotal": {"value": "0", "precision": 20}, "variant_option_values": null, "raw_discount_tax_total": {"value": "0", "precision": 20}, "raw_original_tax_total": {"value": "0", "precision": 20}, "raw_compare_at_unit_price": null}], "total": 20, "region": {"id": "reg_01K465NWZBB589QBS334WRK4PF", "name": "Europe", "metadata": null, "created_at": "2025-09-02T21:35:11.341Z", "deleted_at": null, "updated_at": "2025-09-02T21:35:11.341Z", "currency_code": "eur", "automatic_taxes": true}, "customer": {"id": "cus_01K46A0ZPRWKCSMQAW51DY0W8R", "email": "mk@mk.com", "phone": null, "groups": [], "metadata": null, "last_name": null, "created_at": "2025-09-02T22:51:08.888Z", "created_by": null, "deleted_at": null, "first_name": null, "updated_at": "2025-09-02T22:51:08.888Z", "has_account": false, "company_name": null}, "metadata": null, "subtotal": 20, "region_id": "reg_01K465NWZBB589QBS334WRK4PF", "item_total": 10, "promotions": [], "customer_id": "cus_01K46A0ZPRWKCSMQAW51DY0W8R", "completed_at": null, "currency_code": "eur", "item_subtotal": 10, "sales_channel_id": "sc_01K465NVAAFMSJ0RGP5VCKEPVH", "shipping_address": {"id": "caaddr_01K46A0ZRNPRJP2YKVVCX2RH5W", "city": "varanasi", "phone": "", "company": "", "metadata": null, "province": "up", "address_1": "test", "address_2": "", "last_name": "test", "created_at": "2025-09-02T22:51:08.950Z", "deleted_at": null, "first_name": "test", "updated_at": "2025-09-02T22:51:08.950Z", "customer_id": null, "postal_code": "221002", "country_code": "it"}, "shipping_methods": [{"id": "casm_01K46A12WMTEF0WW2GPAESHJ3N", "data": {}, "name": "Standard Shipping", "total": 10, "amount": 10, "cart_id": "cart_01K466AXHFNSF95BC7REXFZ8B0", "metadata": null, "subtotal": 10, "raw_total": {"value": "10", "precision": 20}, "tax_lines": [], "tax_total": 0, "created_at": "2025-09-02T22:51:12.148Z", "deleted_at": null, "raw_amount": {"value": "10", "precision": 20}, "updated_at": "2025-09-02T22:51:12.148Z", "adjustments": [], "description": null, "raw_subtotal": {"value": "10", "precision": 20}, "raw_tax_total": {"value": "0", "precision": 20}, "discount_total": 0, "original_total": 10, "shipping_option": {"id": "so_01K465NX0W8FHES8P37CAFHZS3", "shipping_option_type_id": "sotype_01K465NX0WGE47H7NC6TPMQ1VT"}, "is_tax_inclusive": false, "discount_subtotal": 0, "discount_tax_total": 0, "original_tax_total": 0, "raw_discount_total": {"value": "0", "precision": 20}, "raw_original_total": {"value": "10", "precision": 20}, "shipping_option_id": "so_01K465NX0W8FHES8P37CAFHZS3", "raw_discount_subtotal": {"value": "0", "precision": 20}, "raw_discount_tax_total": {"value": "0", "precision": 20}, "raw_original_tax_total": {"value": "0", "precision": 20}}], "shipping_subtotal": 10}}, "compensate": {}}, "errors": []}	done	2025-09-02 22:51:12.257	2025-09-02 22:51:12.344	\N	\N	01K46A12RF3RVEMTWBR7A89T82
wf_exec_01K46A135K59JYFD6QGTSG4A88	update-cart-promotions	update-cart-promotions-as-step-refresh-cart-items-as-step-auto-01K46A12RDRJXRB1Y1TVQRHRSN	{"runId": "01K46A12RF3RVEMTWBR7A89T82", "state": "done", "steps": {"_root": {"id": "_root", "next": ["_root.use-remote-query"]}, "_root.use-remote-query": {"id": "_root.use-remote-query", "next": ["_root.use-remote-query.validate"], "uuid": "01K469C7MZRTB0J3E7K3J0NKVN", "depth": 1, "invoke": {"state": "done", "status": "ok"}, "attempts": 1, "failures": 0, "startedAt": 1756853472440, "compensate": {"state": "dormant", "status": "idle"}, "definition": {"uuid": "01K469C7MZRTB0J3E7K3J0NKVN", "action": "use-remote-query", "noCompensation": true}, "stepFailed": false, "lastAttempt": 1756853472440, "saveResponse": true}, "_root.use-remote-query.validate": {"id": "_root.use-remote-query.validate", "next": ["_root.use-remote-query.validate.get-promotion-codes-to-apply"], "uuid": "01K469C7MZZ7DZ9NJTQXHXQBKM", "depth": 2, "invoke": {"state": "done", "status": "ok"}, "attempts": 1, "failures": 0, "startedAt": 1756853472463, "compensate": {"state": "dormant", "status": "idle"}, "definition": {"uuid": "01K469C7MZZ7DZ9NJTQXHXQBKM", "action": "validate", "noCompensation": false}, "stepFailed": false, "lastAttempt": 1756853472463, "saveResponse": true}, "_root.use-remote-query.validate.get-promotion-codes-to-apply": {"id": "_root.use-remote-query.validate.get-promotion-codes-to-apply", "next": ["_root.use-remote-query.validate.get-promotion-codes-to-apply.get-actions-to-compute-from-promotions"], "uuid": "01K469C7MZZEZVY9PFRV35WWVP", "depth": 3, "invoke": {"state": "done", "status": "ok"}, "attempts": 1, "failures": 0, "startedAt": 1756853472474, "compensate": {"state": "dormant", "status": "idle"}, "definition": {"uuid": "01K469C7MZZEZVY9PFRV35WWVP", "action": "get-promotion-codes-to-apply", "noCompensation": true}, "stepFailed": false, "lastAttempt": 1756853472474, "saveResponse": true}, "_root.use-remote-query.validate.get-promotion-codes-to-apply.get-actions-to-compute-from-promotions": {"id": "_root.use-remote-query.validate.get-promotion-codes-to-apply.get-actions-to-compute-from-promotions", "next": ["_root.use-remote-query.validate.get-promotion-codes-to-apply.get-actions-to-compute-from-promotions.prepare-adjustments-from-promotion-actions"], "uuid": "01K469C7MZ230XVA7CPQMNBBZK", "depth": 4, "invoke": {"state": "done", "status": "ok"}, "attempts": 1, "failures": 0, "startedAt": 1756853472484, "compensate": {"state": "dormant", "status": "idle"}, "definition": {"uuid": "01K469C7MZ230XVA7CPQMNBBZK", "action": "get-actions-to-compute-from-promotions", "noCompensation": true}, "stepFailed": false, "lastAttempt": 1756853472484, "saveResponse": true}, "_root.use-remote-query.validate.get-promotion-codes-to-apply.get-actions-to-compute-from-promotions.prepare-adjustments-from-promotion-actions": {"id": "_root.use-remote-query.validate.get-promotion-codes-to-apply.get-actions-to-compute-from-promotions.prepare-adjustments-from-promotion-actions", "next": ["_root.use-remote-query.validate.get-promotion-codes-to-apply.get-actions-to-compute-from-promotions.prepare-adjustments-from-promotion-actions.remove-line-item-adjustments", "_root.use-remote-query.validate.get-promotion-codes-to-apply.get-actions-to-compute-from-promotions.prepare-adjustments-from-promotion-actions.remove-shipping-method-adjustments", "_root.use-remote-query.validate.get-promotion-codes-to-apply.get-actions-to-compute-from-promotions.prepare-adjustments-from-promotion-actions.create-line-item-adjustments", "_root.use-remote-query.validate.get-promotion-codes-to-apply.get-actions-to-compute-from-promotions.prepare-adjustments-from-promotion-actions.create-shipping-method-adjustments", "_root.use-remote-query.validate.get-promotion-codes-to-apply.get-actions-to-compute-from-promotions.prepare-adjustments-from-promotion-actions.update-cart-promotions"], "uuid": "01K469C7MZP1FZ49MXK5KS5WE8", "depth": 5, "invoke": {"state": "done", "status": "ok"}, "attempts": 1, "failures": 0, "startedAt": 1756853472505, "compensate": {"state": "dormant", "status": "idle"}, "definition": {"uuid": "01K469C7MZP1FZ49MXK5KS5WE8", "action": "prepare-adjustments-from-promotion-actions", "noCompensation": true}, "stepFailed": false, "lastAttempt": 1756853472505, "saveResponse": true}, "_root.use-remote-query.validate.get-promotion-codes-to-apply.get-actions-to-compute-from-promotions.prepare-adjustments-from-promotion-actions.update-cart-promotions": {"id": "_root.use-remote-query.validate.get-promotion-codes-to-apply.get-actions-to-compute-from-promotions.prepare-adjustments-from-promotion-actions.update-cart-promotions", "next": [], "uuid": "01K469C7MZJGSJ03P98Z1WX96N", "depth": 6, "invoke": {"state": "done", "status": "ok"}, "attempts": 1, "failures": 0, "startedAt": 1756853472517, "compensate": {"state": "dormant", "status": "idle"}, "definition": {"uuid": "01K469C7MZJGSJ03P98Z1WX96N", "action": "update-cart-promotions", "noCompensation": false}, "stepFailed": false, "lastAttempt": 1756853472517, "saveResponse": true}, "_root.use-remote-query.validate.get-promotion-codes-to-apply.get-actions-to-compute-from-promotions.prepare-adjustments-from-promotion-actions.create-line-item-adjustments": {"id": "_root.use-remote-query.validate.get-promotion-codes-to-apply.get-actions-to-compute-from-promotions.prepare-adjustments-from-promotion-actions.create-line-item-adjustments", "next": [], "uuid": "01K469C7MZXZCWKF2H3VYG92D9", "depth": 6, "invoke": {"state": "done", "status": "ok"}, "attempts": 1, "failures": 0, "startedAt": 1756853472517, "compensate": {"state": "dormant", "status": "idle"}, "definition": {"uuid": "01K469C7MZXZCWKF2H3VYG92D9", "action": "create-line-item-adjustments", "noCompensation": false}, "stepFailed": false, "lastAttempt": 1756853472517, "saveResponse": true}, "_root.use-remote-query.validate.get-promotion-codes-to-apply.get-actions-to-compute-from-promotions.prepare-adjustments-from-promotion-actions.remove-line-item-adjustments": {"id": "_root.use-remote-query.validate.get-promotion-codes-to-apply.get-actions-to-compute-from-promotions.prepare-adjustments-from-promotion-actions.remove-line-item-adjustments", "next": [], "uuid": "01K469C7MZVTP07XXFPT7GTEAN", "depth": 6, "invoke": {"state": "done", "status": "ok"}, "attempts": 1, "failures": 0, "startedAt": 1756853472517, "compensate": {"state": "dormant", "status": "idle"}, "definition": {"uuid": "01K469C7MZVTP07XXFPT7GTEAN", "action": "remove-line-item-adjustments", "noCompensation": false}, "stepFailed": false, "lastAttempt": 1756853472517, "saveResponse": true}, "_root.use-remote-query.validate.get-promotion-codes-to-apply.get-actions-to-compute-from-promotions.prepare-adjustments-from-promotion-actions.create-shipping-method-adjustments": {"id": "_root.use-remote-query.validate.get-promotion-codes-to-apply.get-actions-to-compute-from-promotions.prepare-adjustments-from-promotion-actions.create-shipping-method-adjustments", "next": [], "uuid": "01K469C7MZBETCGP1B1XFG2GAH", "depth": 6, "invoke": {"state": "done", "status": "ok"}, "attempts": 1, "failures": 0, "startedAt": 1756853472517, "compensate": {"state": "dormant", "status": "idle"}, "definition": {"uuid": "01K469C7MZBETCGP1B1XFG2GAH", "action": "create-shipping-method-adjustments", "noCompensation": false}, "stepFailed": false, "lastAttempt": 1756853472517, "saveResponse": true}, "_root.use-remote-query.validate.get-promotion-codes-to-apply.get-actions-to-compute-from-promotions.prepare-adjustments-from-promotion-actions.remove-shipping-method-adjustments": {"id": "_root.use-remote-query.validate.get-promotion-codes-to-apply.get-actions-to-compute-from-promotions.prepare-adjustments-from-promotion-actions.remove-shipping-method-adjustments", "next": [], "uuid": "01K469C7MZH7W9A6EVXK2SEVDY", "depth": 6, "invoke": {"state": "done", "status": "ok"}, "attempts": 1, "failures": 0, "startedAt": 1756853472517, "compensate": {"state": "dormant", "status": "idle"}, "definition": {"uuid": "01K469C7MZH7W9A6EVXK2SEVDY", "action": "remove-shipping-method-adjustments", "noCompensation": false}, "stepFailed": false, "lastAttempt": 1756853472517, "saveResponse": true}}, "modelId": "update-cart-promotions", "options": {"name": "update-cart-promotions", "store": true, "idempotent": true}, "metadata": {"sourcePath": "/Users/mukul/Documents/GitHub/pharmint-marketplace/backend/node_modules/@medusajs/core-flows/dist/cart/workflows/update-cart-promotions.js", "eventGroupId": "01K46A12RD5DTAJW3P0DEHRKZB", "preventReleaseEvents": true, "parentStepIdempotencyKey": "refresh-cart-items:refresh-cart-items-as-step-auto-01K46A12RDRJXRB1Y1TVQRHRSN:update-cart-promotions-as-step:invoke"}, "startedAt": 1756853472437, "definition": {"next": {"next": {"next": {"next": {"next": [{"uuid": "01K469C7MZVTP07XXFPT7GTEAN", "action": "remove-line-item-adjustments", "noCompensation": false}, {"uuid": "01K469C7MZH7W9A6EVXK2SEVDY", "action": "remove-shipping-method-adjustments", "noCompensation": false}, {"uuid": "01K469C7MZXZCWKF2H3VYG92D9", "action": "create-line-item-adjustments", "noCompensation": false}, {"uuid": "01K469C7MZBETCGP1B1XFG2GAH", "action": "create-shipping-method-adjustments", "noCompensation": false}, {"uuid": "01K469C7MZJGSJ03P98Z1WX96N", "action": "update-cart-promotions", "noCompensation": false}], "uuid": "01K469C7MZP1FZ49MXK5KS5WE8", "action": "prepare-adjustments-from-promotion-actions", "noCompensation": true}, "uuid": "01K469C7MZ230XVA7CPQMNBBZK", "action": "get-actions-to-compute-from-promotions", "noCompensation": true}, "uuid": "01K469C7MZZEZVY9PFRV35WWVP", "action": "get-promotion-codes-to-apply", "noCompensation": true}, "uuid": "01K469C7MZZ7DZ9NJTQXHXQBKM", "action": "validate", "noCompensation": false}, "uuid": "01K469C7MZRTB0J3E7K3J0NKVN", "action": "use-remote-query", "noCompensation": true}, "timedOutAt": null, "hasAsyncSteps": false, "transactionId": "update-cart-promotions-as-step-refresh-cart-items-as-step-auto-01K46A12RDRJXRB1Y1TVQRHRSN", "hasFailedSteps": false, "hasSkippedSteps": false, "hasWaitingSteps": false, "hasRevertedSteps": false, "hasSkippedOnFailureSteps": false}	{"data": {"invoke": {"validate": {"__type": "Symbol(WorkflowWorkflowData)", "output": {"__type": "Symbol(WorkflowStepResponse)"}}, "use-remote-query": {"__type": "Symbol(WorkflowWorkflowData)", "output": {"__type": "Symbol(WorkflowStepResponse)", "output": {"id": "cart_01K466AXHFNSF95BC7REXFZ8B0", "items": [{"id": "cali_01K468ECQFE8SQKS9467B5AD66", "title": "Medusa T-Shirt", "total": 10, "cart_id": "cart_01K466AXHFNSF95BC7REXFZ8B0", "product": {"id": "prod_01K465NX26VFWW6C9Y3GJN3K6V", "tags": [], "type_id": null, "categories": [], "is_giftcard": false, "collection_id": null}, "variant": {"id": "variant_01K465NX36QVW4VT9ZBR1WEYPA", "width": null, "height": null, "length": null, "weight": null, "product": {"id": "prod_01K465NX26VFWW6C9Y3GJN3K6V"}, "material": null, "product_id": "prod_01K465NX26VFWW6C9Y3GJN3K6V"}, "metadata": {}, "quantity": 1, "subtitle": "M / Black", "subtotal": 10, "raw_total": {"value": "10", "precision": 20}, "tax_lines": [], "tax_total": 0, "thumbnail": "https://medusa-public-images.s3.eu-west-1.amazonaws.com/tee-black-front.png", "created_at": "2025-09-02T22:23:31.055Z", "deleted_at": null, "product_id": "prod_01K465NX26VFWW6C9Y3GJN3K6V", "unit_price": 10, "updated_at": "2025-09-02T22:23:31.055Z", "variant_id": "variant_01K465NX36QVW4VT9ZBR1WEYPA", "adjustments": [], "is_giftcard": false, "variant_sku": "SHIRT-M-BLACK", "product_type": null, "raw_subtotal": {"value": "10", "precision": 20}, "product_title": "Medusa T-Shirt", "raw_tax_total": {"value": "0", "precision": 20}, "variant_title": "M / Black", "discount_total": 0, "original_total": 10, "product_handle": "t-shirt", "raw_unit_price": {"value": "10", "precision": 20}, "is_custom_price": false, "is_discountable": true, "product_type_id": null, "variant_barcode": null, "is_tax_inclusive": false, "product_subtitle": null, "discount_subtotal": 0, "requires_shipping": true, "discount_tax_total": 0, "original_tax_total": 0, "product_collection": null, "raw_discount_total": {"value": "0", "precision": 20}, "raw_original_total": {"value": "10", "precision": 20}, "product_description": "Reimagine the feeling of a classic T-shirt. With our cotton T-shirts, everyday essentials no longer have to be ordinary.", "compare_at_unit_price": null, "raw_discount_subtotal": {"value": "0", "precision": 20}, "variant_option_values": null, "raw_discount_tax_total": {"value": "0", "precision": 20}, "raw_original_tax_total": {"value": "0", "precision": 20}, "raw_compare_at_unit_price": null}], "total": 20, "region": {"id": "reg_01K465NWZBB589QBS334WRK4PF", "name": "Europe", "metadata": null, "created_at": "2025-09-02T21:35:11.341Z", "deleted_at": null, "updated_at": "2025-09-02T21:35:11.341Z", "currency_code": "eur", "automatic_taxes": true}, "customer": {"id": "cus_01K46A0ZPRWKCSMQAW51DY0W8R", "email": "mk@mk.com", "phone": null, "groups": [], "metadata": null, "last_name": null, "created_at": "2025-09-02T22:51:08.888Z", "created_by": null, "deleted_at": null, "first_name": null, "updated_at": "2025-09-02T22:51:08.888Z", "has_account": false, "company_name": null}, "metadata": null, "subtotal": 20, "region_id": "reg_01K465NWZBB589QBS334WRK4PF", "item_total": 10, "promotions": [], "customer_id": "cus_01K46A0ZPRWKCSMQAW51DY0W8R", "completed_at": null, "currency_code": "eur", "item_subtotal": 10, "sales_channel_id": "sc_01K465NVAAFMSJ0RGP5VCKEPVH", "shipping_address": {"id": "caaddr_01K46A0ZRNPRJP2YKVVCX2RH5W", "city": "varanasi", "phone": "", "company": "", "metadata": null, "province": "up", "address_1": "test", "address_2": "", "last_name": "test", "created_at": "2025-09-02T22:51:08.950Z", "deleted_at": null, "first_name": "test", "updated_at": "2025-09-02T22:51:08.950Z", "customer_id": null, "postal_code": "221002", "country_code": "it"}, "shipping_methods": [{"id": "casm_01K46A12WMTEF0WW2GPAESHJ3N", "data": {}, "name": "Standard Shipping", "total": 10, "amount": 10, "cart_id": "cart_01K466AXHFNSF95BC7REXFZ8B0", "metadata": null, "subtotal": 10, "raw_total": {"value": "10", "precision": 20}, "tax_lines": [], "tax_total": 0, "created_at": "2025-09-02T22:51:12.148Z", "deleted_at": null, "raw_amount": {"value": "10", "precision": 20}, "updated_at": "2025-09-02T22:51:12.148Z", "adjustments": [], "description": null, "raw_subtotal": {"value": "10", "precision": 20}, "raw_tax_total": {"value": "0", "precision": 20}, "discount_total": 0, "original_total": 10, "shipping_option": {"id": "so_01K465NX0W8FHES8P37CAFHZS3", "shipping_option_type_id": "sotype_01K465NX0WGE47H7NC6TPMQ1VT"}, "is_tax_inclusive": false, "discount_subtotal": 0, "discount_tax_total": 0, "original_tax_total": 0, "raw_discount_total": {"value": "0", "precision": 20}, "raw_original_total": {"value": "10", "precision": 20}, "shipping_option_id": "so_01K465NX0W8FHES8P37CAFHZS3", "raw_discount_subtotal": {"value": "0", "precision": 20}, "raw_discount_tax_total": {"value": "0", "precision": 20}, "raw_original_tax_total": {"value": "0", "precision": 20}}], "shipping_subtotal": 10}, "compensateInput": {"id": "cart_01K466AXHFNSF95BC7REXFZ8B0", "items": [{"id": "cali_01K468ECQFE8SQKS9467B5AD66", "title": "Medusa T-Shirt", "total": 10, "cart_id": "cart_01K466AXHFNSF95BC7REXFZ8B0", "product": {"id": "prod_01K465NX26VFWW6C9Y3GJN3K6V", "tags": [], "type_id": null, "categories": [], "is_giftcard": false, "collection_id": null}, "variant": {"id": "variant_01K465NX36QVW4VT9ZBR1WEYPA", "width": null, "height": null, "length": null, "weight": null, "product": {"id": "prod_01K465NX26VFWW6C9Y3GJN3K6V"}, "material": null, "product_id": "prod_01K465NX26VFWW6C9Y3GJN3K6V"}, "metadata": {}, "quantity": 1, "subtitle": "M / Black", "subtotal": 10, "raw_total": {"value": "10", "precision": 20}, "tax_lines": [], "tax_total": 0, "thumbnail": "https://medusa-public-images.s3.eu-west-1.amazonaws.com/tee-black-front.png", "created_at": "2025-09-02T22:23:31.055Z", "deleted_at": null, "product_id": "prod_01K465NX26VFWW6C9Y3GJN3K6V", "unit_price": 10, "updated_at": "2025-09-02T22:23:31.055Z", "variant_id": "variant_01K465NX36QVW4VT9ZBR1WEYPA", "adjustments": [], "is_giftcard": false, "variant_sku": "SHIRT-M-BLACK", "product_type": null, "raw_subtotal": {"value": "10", "precision": 20}, "product_title": "Medusa T-Shirt", "raw_tax_total": {"value": "0", "precision": 20}, "variant_title": "M / Black", "discount_total": 0, "original_total": 10, "product_handle": "t-shirt", "raw_unit_price": {"value": "10", "precision": 20}, "is_custom_price": false, "is_discountable": true, "product_type_id": null, "variant_barcode": null, "is_tax_inclusive": false, "product_subtitle": null, "discount_subtotal": 0, "requires_shipping": true, "discount_tax_total": 0, "original_tax_total": 0, "product_collection": null, "raw_discount_total": {"value": "0", "precision": 20}, "raw_original_total": {"value": "10", "precision": 20}, "product_description": "Reimagine the feeling of a classic T-shirt. With our cotton T-shirts, everyday essentials no longer have to be ordinary.", "compare_at_unit_price": null, "raw_discount_subtotal": {"value": "0", "precision": 20}, "variant_option_values": null, "raw_discount_tax_total": {"value": "0", "precision": 20}, "raw_original_tax_total": {"value": "0", "precision": 20}, "raw_compare_at_unit_price": null}], "total": 20, "region": {"id": "reg_01K465NWZBB589QBS334WRK4PF", "name": "Europe", "metadata": null, "created_at": "2025-09-02T21:35:11.341Z", "deleted_at": null, "updated_at": "2025-09-02T21:35:11.341Z", "currency_code": "eur", "automatic_taxes": true}, "customer": {"id": "cus_01K46A0ZPRWKCSMQAW51DY0W8R", "email": "mk@mk.com", "phone": null, "groups": [], "metadata": null, "last_name": null, "created_at": "2025-09-02T22:51:08.888Z", "created_by": null, "deleted_at": null, "first_name": null, "updated_at": "2025-09-02T22:51:08.888Z", "has_account": false, "company_name": null}, "metadata": null, "subtotal": 20, "region_id": "reg_01K465NWZBB589QBS334WRK4PF", "item_total": 10, "promotions": [], "customer_id": "cus_01K46A0ZPRWKCSMQAW51DY0W8R", "completed_at": null, "currency_code": "eur", "item_subtotal": 10, "sales_channel_id": "sc_01K465NVAAFMSJ0RGP5VCKEPVH", "shipping_address": {"id": "caaddr_01K46A0ZRNPRJP2YKVVCX2RH5W", "city": "varanasi", "phone": "", "company": "", "metadata": null, "province": "up", "address_1": "test", "address_2": "", "last_name": "test", "created_at": "2025-09-02T22:51:08.950Z", "deleted_at": null, "first_name": "test", "updated_at": "2025-09-02T22:51:08.950Z", "customer_id": null, "postal_code": "221002", "country_code": "it"}, "shipping_methods": [{"id": "casm_01K46A12WMTEF0WW2GPAESHJ3N", "data": {}, "name": "Standard Shipping", "total": 10, "amount": 10, "cart_id": "cart_01K466AXHFNSF95BC7REXFZ8B0", "metadata": null, "subtotal": 10, "raw_total": {"value": "10", "precision": 20}, "tax_lines": [], "tax_total": 0, "created_at": "2025-09-02T22:51:12.148Z", "deleted_at": null, "raw_amount": {"value": "10", "precision": 20}, "updated_at": "2025-09-02T22:51:12.148Z", "adjustments": [], "description": null, "raw_subtotal": {"value": "10", "precision": 20}, "raw_tax_total": {"value": "0", "precision": 20}, "discount_total": 0, "original_total": 10, "shipping_option": {"id": "so_01K465NX0W8FHES8P37CAFHZS3", "shipping_option_type_id": "sotype_01K465NX0WGE47H7NC6TPMQ1VT"}, "is_tax_inclusive": false, "discount_subtotal": 0, "discount_tax_total": 0, "original_tax_total": 0, "raw_discount_total": {"value": "0", "precision": 20}, "raw_original_total": {"value": "10", "precision": 20}, "shipping_option_id": "so_01K465NX0W8FHES8P37CAFHZS3", "raw_discount_subtotal": {"value": "0", "precision": 20}, "raw_discount_tax_total": {"value": "0", "precision": 20}, "raw_original_tax_total": {"value": "0", "precision": 20}}], "shipping_subtotal": 10}}}, "update-cart-promotions": {"__type": "Symbol(WorkflowWorkflowData)", "output": {"__type": "Symbol(WorkflowStepResponse)", "output": null, "compensateInput": {"createdLinkIds": [], "dismissedLinks": []}}}, "create-line-item-adjustments": {"__type": "Symbol(WorkflowWorkflowData)", "output": {"__type": "Symbol(WorkflowStepResponse)", "output": [], "compensateInput": []}}, "get-promotion-codes-to-apply": {"__type": "Symbol(WorkflowWorkflowData)", "output": {"__type": "Symbol(WorkflowStepResponse)", "output": [], "compensateInput": []}}, "remove-line-item-adjustments": {"__type": "Symbol(WorkflowWorkflowData)", "output": {"__type": "Symbol(WorkflowStepResponse)", "compensateInput": []}}, "create-shipping-method-adjustments": {"__type": "Symbol(WorkflowWorkflowData)", "output": {"__type": "Symbol(WorkflowStepResponse)", "compensateInput": []}}, "remove-shipping-method-adjustments": {"__type": "Symbol(WorkflowWorkflowData)", "output": {"__type": "Symbol(WorkflowStepResponse)", "compensateInput": []}}, "get-actions-to-compute-from-promotions": {"__type": "Symbol(WorkflowWorkflowData)", "output": {"__type": "Symbol(WorkflowStepResponse)", "output": [], "compensateInput": []}}, "prepare-adjustments-from-promotion-actions": {"__type": "Symbol(WorkflowWorkflowData)", "output": {"__type": "Symbol(WorkflowStepResponse)", "output": {"computedPromotionCodes": [], "lineItemAdjustmentsToCreate": [], "lineItemAdjustmentIdsToRemove": [], "shippingMethodAdjustmentsToCreate": [], "shippingMethodAdjustmentIdsToRemove": []}, "compensateInput": {"computedPromotionCodes": [], "lineItemAdjustmentsToCreate": [], "lineItemAdjustmentIdsToRemove": [], "shippingMethodAdjustmentsToCreate": [], "shippingMethodAdjustmentIdsToRemove": []}}}}, "payload": {"action": "replace", "cart_id": "cart_01K466AXHFNSF95BC7REXFZ8B0", "promo_codes": []}, "compensate": {}}, "errors": []}	done	2025-09-02 22:51:12.435	2025-09-02 22:51:12.538	\N	\N	01K46A12RF3RVEMTWBR7A89T82
wf_exec_01K46A13B4XHY8PD6PX9YR4FKW	refresh-payment-collection-for-cart	refresh-payment-collection-for-cart-as-step-refresh-cart-items-as-step-auto-01K46A12RDRJXRB1Y1TVQRHRSN	{"runId": "01K46A12RF3RVEMTWBR7A89T82", "state": "done", "steps": {"_root": {"id": "_root", "next": ["_root.use-remote-query"]}, "_root.use-remote-query": {"id": "_root.use-remote-query", "next": ["_root.use-remote-query.validate"], "uuid": "01K469C7MYE6F5K2A9J8T5ANE7", "depth": 1, "invoke": {"state": "done", "status": "ok"}, "attempts": 1, "failures": 0, "startedAt": 1756853472616, "compensate": {"state": "dormant", "status": "idle"}, "definition": {"uuid": "01K469C7MYE6F5K2A9J8T5ANE7", "action": "use-remote-query", "noCompensation": true}, "stepFailed": false, "lastAttempt": 1756853472616, "saveResponse": true}, "_root.use-remote-query.validate": {"id": "_root.use-remote-query.validate", "next": ["_root.use-remote-query.validate.delete-payment-sessions-as-step", "_root.use-remote-query.validate.update-payment-collection"], "uuid": "01K469C7MYP3P45ZM4P72S2XKS", "depth": 2, "invoke": {"state": "done", "status": "ok"}, "attempts": 1, "failures": 0, "startedAt": 1756853472628, "compensate": {"state": "dormant", "status": "idle"}, "definition": {"uuid": "01K469C7MYP3P45ZM4P72S2XKS", "action": "validate", "noCompensation": false}, "stepFailed": false, "lastAttempt": 1756853472628, "saveResponse": true}, "_root.use-remote-query.validate.update-payment-collection": {"id": "_root.use-remote-query.validate.update-payment-collection", "next": [], "uuid": "01K469C7MYBEYF34R5J2GCFD10", "depth": 3, "invoke": {"state": "done", "status": "ok"}, "attempts": 1, "failures": 0, "startedAt": 1756853472633, "compensate": {"state": "dormant", "status": "idle"}, "definition": {"uuid": "01K469C7MYBEYF34R5J2GCFD10", "action": "update-payment-collection", "noCompensation": false}, "stepFailed": false, "lastAttempt": 1756853472633, "saveResponse": true}, "_root.use-remote-query.validate.delete-payment-sessions-as-step": {"id": "_root.use-remote-query.validate.delete-payment-sessions-as-step", "next": [], "uuid": "01K469C7MYJ7W7X0X2VZ7HA3V2", "depth": 3, "invoke": {"state": "done", "status": "ok"}, "attempts": 1, "failures": 0, "startedAt": 1756853472633, "compensate": {"state": "dormant", "status": "idle"}, "definition": {"name": "delete-payment-sessions-as-step", "uuid": "01K469C7MYJ7W7X0X2VZ7HA3V2", "async": false, "action": "delete-payment-sessions-as-step", "nested": false, "noCompensation": false}, "stepFailed": false, "lastAttempt": 1756853472633, "saveResponse": true}}, "modelId": "refresh-payment-collection-for-cart", "options": {"name": "refresh-payment-collection-for-cart", "store": true, "idempotent": true}, "metadata": {"sourcePath": "/Users/mukul/Documents/GitHub/pharmint-marketplace/backend/node_modules/@medusajs/core-flows/dist/cart/workflows/refresh-payment-collection.js", "eventGroupId": "01K46A12RD5DTAJW3P0DEHRKZB", "preventReleaseEvents": true, "parentStepIdempotencyKey": "refresh-cart-items:refresh-cart-items-as-step-auto-01K46A12RDRJXRB1Y1TVQRHRSN:refresh-payment-collection-for-cart-as-step:invoke"}, "startedAt": 1756853472613, "definition": {"next": {"next": [{"name": "delete-payment-sessions-as-step", "uuid": "01K469C7MYJ7W7X0X2VZ7HA3V2", "async": false, "action": "delete-payment-sessions-as-step", "nested": false, "noCompensation": false}, {"uuid": "01K469C7MYBEYF34R5J2GCFD10", "action": "update-payment-collection", "noCompensation": false}], "uuid": "01K469C7MYP3P45ZM4P72S2XKS", "action": "validate", "noCompensation": false}, "uuid": "01K469C7MYE6F5K2A9J8T5ANE7", "action": "use-remote-query", "noCompensation": true}, "timedOutAt": null, "hasAsyncSteps": false, "transactionId": "refresh-payment-collection-for-cart-as-step-refresh-cart-items-as-step-auto-01K46A12RDRJXRB1Y1TVQRHRSN", "hasFailedSteps": false, "hasSkippedSteps": false, "hasWaitingSteps": false, "hasRevertedSteps": false, "hasSkippedOnFailureSteps": false}	{"data": {"invoke": {"validate": {"__type": "Symbol(WorkflowWorkflowData)", "output": {"__type": "Symbol(WorkflowStepResponse)"}}, "use-remote-query": {"__type": "Symbol(WorkflowWorkflowData)", "output": {"__type": "Symbol(WorkflowStepResponse)", "output": {"id": "cart_01K466AXHFNSF95BC7REXFZ8B0", "total": 20, "raw_total": {"value": "20", "precision": 20}, "region_id": "reg_01K465NWZBB589QBS334WRK4PF", "currency_code": "eur"}, "compensateInput": {"id": "cart_01K466AXHFNSF95BC7REXFZ8B0", "total": 20, "raw_total": {"value": "20", "precision": 20}, "region_id": "reg_01K465NWZBB589QBS334WRK4PF", "currency_code": "eur"}}}, "update-payment-collection": {"__type": "Symbol(WorkflowWorkflowData)", "output": {"__type": "Symbol(WorkflowStepResponse)", "output": [], "compensateInput": []}}, "delete-payment-sessions-as-step": {"__type": "Symbol(WorkflowWorkflowData)", "output": {"__type": "Symbol(WorkflowStepResponse)", "output": [], "compensateInput": {"errors": [], "result": [], "thrownError": null, "transaction": {"flow": {"runId": "01K46A12RF3RVEMTWBR7A89T82", "state": "done", "steps": {"_root": {"id": "_root", "next": ["_root.delete-payment-sessions"]}, "_root.delete-payment-sessions": {"id": "_root.delete-payment-sessions", "next": ["_root.delete-payment-sessions.validate-deleted-payment-sessions"], "uuid": "01K469C7MW8WCT5KNWMBT8NWF4", "depth": 1, "invoke": {"state": "done", "status": "ok"}, "attempts": 1, "failures": 0, "startedAt": 1756853472636, "compensate": {"state": "dormant", "status": "idle"}, "definition": {"uuid": "01K469C7MW8WCT5KNWMBT8NWF4", "action": "delete-payment-sessions", "noCompensation": false}, "stepFailed": false, "lastAttempt": 1756853472636, "saveResponse": true}, "_root.delete-payment-sessions.validate-deleted-payment-sessions": {"id": "_root.delete-payment-sessions.validate-deleted-payment-sessions", "next": [], "uuid": "01K469C7MWVT1ZWZRD399W09VN", "depth": 2, "invoke": {"state": "done", "status": "ok"}, "attempts": 1, "failures": 0, "startedAt": 1756853472636, "compensate": {"state": "dormant", "status": "idle"}, "definition": {"uuid": "01K469C7MWVT1ZWZRD399W09VN", "action": "validate-deleted-payment-sessions", "noCompensation": true}, "stepFailed": false, "lastAttempt": 1756853472636, "saveResponse": true}}, "modelId": "delete-payment-sessions", "options": {}, "metadata": {"sourcePath": "/Users/mukul/Documents/GitHub/pharmint-marketplace/backend/node_modules/@medusajs/core-flows/dist/payment-collection/workflows/delete-payment-sessions.js", "eventGroupId": "01K46A12RD5DTAJW3P0DEHRKZB", "preventReleaseEvents": true, "parentStepIdempotencyKey": "refresh-payment-collection-for-cart:refresh-payment-collection-for-cart-as-step-refresh-cart-items-as-step-auto-01K46A12RDRJXRB1Y1TVQRHRSN:delete-payment-sessions-as-step:invoke"}, "startedAt": 1756853472636, "definition": {"next": {"uuid": "01K469C7MWVT1ZWZRD399W09VN", "action": "validate-deleted-payment-sessions", "noCompensation": true}, "uuid": "01K469C7MW8WCT5KNWMBT8NWF4", "action": "delete-payment-sessions", "noCompensation": false}, "timedOutAt": null, "hasAsyncSteps": false, "transactionId": "delete-payment-sessions-as-step-refresh-payment-collection-for-cart-as-step-refresh-cart-items-as-step-auto-01K46A12RDRJXRB1Y1TVQRHRSN", "hasFailedSteps": false, "hasSkippedSteps": false, "hasWaitingSteps": false, "hasRevertedSteps": false, "hasSkippedOnFailureSteps": false}, "runId": "01K46A12RF3RVEMTWBR7A89T82", "errors": [], "_events": {}, "context": {"invoke": {"delete-payment-sessions": {"__type": "Symbol(WorkflowWorkflowData)", "output": {"__type": "Symbol(WorkflowStepResponse)", "output": [], "compensateInput": null}}, "validate-deleted-payment-sessions": {"__type": "Symbol(WorkflowWorkflowData)", "output": {"__type": "Symbol(WorkflowStepResponse)"}}}, "payload": {"ids": []}, "compensate": {}}, "modelId": "delete-payment-sessions", "payload": {"ids": []}, "_eventsCount": 0, "transactionId": "delete-payment-sessions-as-step-refresh-payment-collection-for-cart-as-step-refresh-cart-items-as-step-auto-01K46A12RDRJXRB1Y1TVQRHRSN"}}}}}, "payload": {"cart_id": "cart_01K466AXHFNSF95BC7REXFZ8B0"}, "compensate": {}}, "errors": []}	done	2025-09-02 22:51:12.612	2025-09-02 22:51:12.641	\N	\N	01K46A12RF3RVEMTWBR7A89T82
wf_exec_01K46A1CGCB225VYPQ8YFK0GR7	complete-cart	cart_01K466AXHFNSF95BC7REXFZ8B0	{"runId": "01K46A1CG981BPHT37QNXGE1ME", "state": "done", "steps": {"_root": {"id": "_root", "next": ["_root.acquire-lock-step"]}, "_root.acquire-lock-step": {"id": "_root.acquire-lock-step", "next": ["_root.acquire-lock-step.use-query-graph-step"], "uuid": "01K469C7NA5PA00VW0HZ800ZYV", "depth": 1, "invoke": {"state": "done", "status": "ok"}, "attempts": 1, "failures": 0, "startedAt": 1756853482004, "compensate": {"state": "dormant", "status": "idle"}, "definition": {"uuid": "01K469C7NA5PA00VW0HZ800ZYV", "action": "acquire-lock-step", "noCompensation": false}, "stepFailed": false, "lastAttempt": 1756853482004, "saveResponse": true}, "_root.acquire-lock-step.use-query-graph-step": {"id": "_root.acquire-lock-step.use-query-graph-step", "next": ["_root.acquire-lock-step.use-query-graph-step.cart-query"], "uuid": "01K469C7NAJY5NVA5TX7Y57K7Q", "depth": 2, "invoke": {"state": "done", "status": "ok"}, "attempts": 1, "failures": 0, "startedAt": 1756853482023, "compensate": {"state": "dormant", "status": "idle"}, "definition": {"uuid": "01K469C7NAJY5NVA5TX7Y57K7Q", "action": "use-query-graph-step", "noCompensation": true}, "stepFailed": false, "lastAttempt": 1756853482023, "saveResponse": true}, "_root.acquire-lock-step.use-query-graph-step.cart-query": {"id": "_root.acquire-lock-step.use-query-graph-step.cart-query", "next": ["_root.acquire-lock-step.use-query-graph-step.cart-query.validate-cart-payments"], "uuid": "01K469C7NA2KJ693P3WT423CSN", "depth": 3, "invoke": {"state": "done", "status": "ok"}, "attempts": 1, "failures": 0, "startedAt": 1756853482036, "compensate": {"state": "dormant", "status": "idle"}, "definition": {"uuid": "01K469C7NA2KJ693P3WT423CSN", "async": false, "action": "cart-query", "noCompensation": true, "compensateAsync": false}, "stepFailed": false, "lastAttempt": 1756853482036, "saveResponse": true}, "_root.acquire-lock-step.use-query-graph-step.cart-query.validate-cart-payments": {"id": "_root.acquire-lock-step.use-query-graph-step.cart-query.validate-cart-payments", "next": ["_root.acquire-lock-step.use-query-graph-step.cart-query.validate-cart-payments.compensate-payment-if-needed"], "uuid": "01K469C7NAJ7SE00HXZ57WMM3S", "depth": 4, "invoke": {"state": "done", "status": "ok"}, "attempts": 1, "failures": 0, "startedAt": 1756853482079, "compensate": {"state": "dormant", "status": "idle"}, "definition": {"uuid": "01K469C7NAJ7SE00HXZ57WMM3S", "action": "validate-cart-payments", "noCompensation": true}, "stepFailed": false, "lastAttempt": 1756853482079, "saveResponse": true}, "_root.acquire-lock-step.use-query-graph-step.cart-query.validate-cart-payments.compensate-payment-if-needed": {"id": "_root.acquire-lock-step.use-query-graph-step.cart-query.validate-cart-payments.compensate-payment-if-needed", "next": ["_root.acquire-lock-step.use-query-graph-step.cart-query.validate-cart-payments.compensate-payment-if-needed.validate"], "uuid": "01K469C7NARPX5YA98BGKSE44V", "depth": 5, "invoke": {"state": "done", "status": "ok"}, "attempts": 1, "failures": 0, "startedAt": 1756853482092, "compensate": {"state": "dormant", "status": "idle"}, "definition": {"uuid": "01K469C7NARPX5YA98BGKSE44V", "action": "compensate-payment-if-needed", "noCompensation": false}, "stepFailed": false, "lastAttempt": 1756853482092, "saveResponse": true}, "_root.acquire-lock-step.use-query-graph-step.cart-query.validate-cart-payments.compensate-payment-if-needed.validate": {"id": "_root.acquire-lock-step.use-query-graph-step.cart-query.validate-cart-payments.compensate-payment-if-needed.validate", "next": ["_root.acquire-lock-step.use-query-graph-step.cart-query.validate-cart-payments.compensate-payment-if-needed.validate.shipping-options-query"], "uuid": "01K469C7NABP2XFS7294VH70PV", "depth": 6, "invoke": {"state": "done", "status": "ok"}, "attempts": 1, "failures": 0, "startedAt": 1756853482105, "compensate": {"state": "dormant", "status": "idle"}, "definition": {"uuid": "01K469C7NABP2XFS7294VH70PV", "action": "validate", "noCompensation": false}, "stepFailed": false, "lastAttempt": 1756853482105, "saveResponse": true}, "_root.acquire-lock-step.use-query-graph-step.cart-query.validate-cart-payments.compensate-payment-if-needed.validate.shipping-options-query": {"id": "_root.acquire-lock-step.use-query-graph-step.cart-query.validate-cart-payments.compensate-payment-if-needed.validate.shipping-options-query", "next": ["_root.acquire-lock-step.use-query-graph-step.cart-query.validate-cart-payments.compensate-payment-if-needed.validate.shipping-options-query.validate-shipping"], "uuid": "01K469C7NA4D327ZN0C6R8WVFF", "depth": 7, "invoke": {"state": "done", "status": "ok"}, "attempts": 1, "failures": 0, "startedAt": 1756853482119, "compensate": {"state": "dormant", "status": "idle"}, "definition": {"uuid": "01K469C7NA4D327ZN0C6R8WVFF", "async": false, "action": "shipping-options-query", "noCompensation": true, "compensateAsync": false}, "stepFailed": false, "lastAttempt": 1756853482119, "saveResponse": true}, "_root.acquire-lock-step.use-query-graph-step.cart-query.validate-cart-payments.compensate-payment-if-needed.validate.shipping-options-query.validate-shipping": {"id": "_root.acquire-lock-step.use-query-graph-step.cart-query.validate-cart-payments.compensate-payment-if-needed.validate.shipping-options-query.validate-shipping", "next": ["_root.acquire-lock-step.use-query-graph-step.cart-query.validate-cart-payments.compensate-payment-if-needed.validate.shipping-options-query.validate-shipping.create-orders"], "uuid": "01K469C7NAZT6EGHN1BDZHMD5E", "depth": 8, "invoke": {"state": "done", "status": "ok"}, "attempts": 1, "failures": 0, "startedAt": 1756853482136, "compensate": {"state": "dormant", "status": "idle"}, "definition": {"uuid": "01K469C7NAZT6EGHN1BDZHMD5E", "action": "validate-shipping", "noCompensation": true}, "stepFailed": false, "lastAttempt": 1756853482136, "saveResponse": true}, "_root.acquire-lock-step.use-query-graph-step.cart-query.validate-cart-payments.compensate-payment-if-needed.validate.shipping-options-query.validate-shipping.create-orders": {"id": "_root.acquire-lock-step.use-query-graph-step.cart-query.validate-cart-payments.compensate-payment-if-needed.validate.shipping-options-query.validate-shipping.create-orders", "next": ["_root.acquire-lock-step.use-query-graph-step.cart-query.validate-cart-payments.compensate-payment-if-needed.validate.shipping-options-query.validate-shipping.create-orders.create-remote-links", "_root.acquire-lock-step.use-query-graph-step.cart-query.validate-cart-payments.compensate-payment-if-needed.validate.shipping-options-query.validate-shipping.create-orders.update-carts", "_root.acquire-lock-step.use-query-graph-step.cart-query.validate-cart-payments.compensate-payment-if-needed.validate.shipping-options-query.validate-shipping.create-orders.reserve-inventory-step", "_root.acquire-lock-step.use-query-graph-step.cart-query.validate-cart-payments.compensate-payment-if-needed.validate.shipping-options-query.validate-shipping.create-orders.register-usage", "_root.acquire-lock-step.use-query-graph-step.cart-query.validate-cart-payments.compensate-payment-if-needed.validate.shipping-options-query.validate-shipping.create-orders.emit-event-step"], "uuid": "01K469C7NA8GH0WCZ7WFHTDBSR", "depth": 9, "invoke": {"state": "done", "status": "ok"}, "attempts": 1, "failures": 0, "startedAt": 1756853482153, "compensate": {"state": "dormant", "status": "idle"}, "definition": {"uuid": "01K469C7NA8GH0WCZ7WFHTDBSR", "action": "create-orders", "noCompensation": false}, "stepFailed": false, "lastAttempt": 1756853482153, "saveResponse": true}, "_root.acquire-lock-step.use-query-graph-step.cart-query.validate-cart-payments.compensate-payment-if-needed.validate.shipping-options-query.validate-shipping.create-orders.update-carts": {"id": "_root.acquire-lock-step.use-query-graph-step.cart-query.validate-cart-payments.compensate-payment-if-needed.validate.shipping-options-query.validate-shipping.create-orders.update-carts", "next": [], "uuid": "01K469C7NB1MDEMDE6H0T395XE", "depth": 10, "invoke": {"state": "done", "status": "ok"}, "attempts": 1, "failures": 0, "startedAt": 1756853482226, "compensate": {"state": "dormant", "status": "idle"}, "definition": {"uuid": "01K469C7NB1MDEMDE6H0T395XE", "action": "update-carts", "noCompensation": false}, "stepFailed": false, "lastAttempt": 1756853482226, "saveResponse": true}, "_root.acquire-lock-step.use-query-graph-step.cart-query.validate-cart-payments.compensate-payment-if-needed.validate.shipping-options-query.validate-shipping.create-orders.register-usage": {"id": "_root.acquire-lock-step.use-query-graph-step.cart-query.validate-cart-payments.compensate-payment-if-needed.validate.shipping-options-query.validate-shipping.create-orders.register-usage", "next": [], "uuid": "01K469C7NBADY8DSRRAZSBZNYE", "depth": 10, "invoke": {"state": "done", "status": "ok"}, "attempts": 1, "failures": 0, "startedAt": 1756853482226, "compensate": {"state": "dormant", "status": "idle"}, "definition": {"uuid": "01K469C7NBADY8DSRRAZSBZNYE", "action": "register-usage", "noCompensation": false}, "stepFailed": false, "lastAttempt": 1756853482226, "saveResponse": true}, "_root.acquire-lock-step.use-query-graph-step.cart-query.validate-cart-payments.compensate-payment-if-needed.validate.shipping-options-query.validate-shipping.create-orders.emit-event-step": {"id": "_root.acquire-lock-step.use-query-graph-step.cart-query.validate-cart-payments.compensate-payment-if-needed.validate.shipping-options-query.validate-shipping.create-orders.emit-event-step", "next": ["_root.acquire-lock-step.use-query-graph-step.cart-query.validate-cart-payments.compensate-payment-if-needed.validate.shipping-options-query.validate-shipping.create-orders.emit-event-step.beforePaymentAuthorization"], "uuid": "01K469C7NB2BXBC20K8B9XY14E", "depth": 10, "invoke": {"state": "done", "status": "ok"}, "attempts": 1, "failures": 0, "startedAt": 1756853482226, "compensate": {"state": "dormant", "status": "idle"}, "definition": {"uuid": "01K469C7NB2BXBC20K8B9XY14E", "action": "emit-event-step", "noCompensation": false}, "stepFailed": false, "lastAttempt": 1756853482226, "saveResponse": true}, "_root.acquire-lock-step.use-query-graph-step.cart-query.validate-cart-payments.compensate-payment-if-needed.validate.shipping-options-query.validate-shipping.create-orders.create-remote-links": {"id": "_root.acquire-lock-step.use-query-graph-step.cart-query.validate-cart-payments.compensate-payment-if-needed.validate.shipping-options-query.validate-shipping.create-orders.create-remote-links", "next": [], "uuid": "01K469C7NBA28SPGPP6Y106KP3", "depth": 10, "invoke": {"state": "done", "status": "ok"}, "attempts": 1, "failures": 0, "startedAt": 1756853482226, "compensate": {"state": "dormant", "status": "idle"}, "definition": {"uuid": "01K469C7NBA28SPGPP6Y106KP3", "action": "create-remote-links", "noCompensation": false}, "stepFailed": false, "lastAttempt": 1756853482226, "saveResponse": true}, "_root.acquire-lock-step.use-query-graph-step.cart-query.validate-cart-payments.compensate-payment-if-needed.validate.shipping-options-query.validate-shipping.create-orders.reserve-inventory-step": {"id": "_root.acquire-lock-step.use-query-graph-step.cart-query.validate-cart-payments.compensate-payment-if-needed.validate.shipping-options-query.validate-shipping.create-orders.reserve-inventory-step", "next": [], "uuid": "01K469C7NBFMPYXH332EK3M0XY", "depth": 10, "invoke": {"state": "done", "status": "ok"}, "attempts": 1, "failures": 0, "startedAt": 1756853482226, "compensate": {"state": "dormant", "status": "idle"}, "definition": {"uuid": "01K469C7NBFMPYXH332EK3M0XY", "action": "reserve-inventory-step", "noCompensation": false}, "stepFailed": false, "lastAttempt": 1756853482226, "saveResponse": true}, "_root.acquire-lock-step.use-query-graph-step.cart-query.validate-cart-payments.compensate-payment-if-needed.validate.shipping-options-query.validate-shipping.create-orders.emit-event-step.beforePaymentAuthorization": {"id": "_root.acquire-lock-step.use-query-graph-step.cart-query.validate-cart-payments.compensate-payment-if-needed.validate.shipping-options-query.validate-shipping.create-orders.emit-event-step.beforePaymentAuthorization", "next": ["_root.acquire-lock-step.use-query-graph-step.cart-query.validate-cart-payments.compensate-payment-if-needed.validate.shipping-options-query.validate-shipping.create-orders.emit-event-step.beforePaymentAuthorization.authorize-payment-session-step"], "uuid": "01K469C7NBV3YEQXNR3DTSHJG4", "depth": 11, "invoke": {"state": "done", "status": "ok"}, "attempts": 1, "failures": 0, "startedAt": 1756853482260, "compensate": {"state": "dormant", "status": "idle"}, "definition": {"uuid": "01K469C7NBV3YEQXNR3DTSHJG4", "action": "beforePaymentAuthorization", "noCompensation": false}, "stepFailed": false, "lastAttempt": 1756853482260, "saveResponse": true}, "_root.acquire-lock-step.use-query-graph-step.cart-query.validate-cart-payments.compensate-payment-if-needed.validate.shipping-options-query.validate-shipping.create-orders.emit-event-step.beforePaymentAuthorization.authorize-payment-session-step": {"id": "_root.acquire-lock-step.use-query-graph-step.cart-query.validate-cart-payments.compensate-payment-if-needed.validate.shipping-options-query.validate-shipping.create-orders.emit-event-step.beforePaymentAuthorization.authorize-payment-session-step", "next": ["_root.acquire-lock-step.use-query-graph-step.cart-query.validate-cart-payments.compensate-payment-if-needed.validate.shipping-options-query.validate-shipping.create-orders.emit-event-step.beforePaymentAuthorization.authorize-payment-session-step.add-order-transaction"], "uuid": "01K469C7NBAGB5B2E9YE6N73AK", "depth": 12, "invoke": {"state": "done", "status": "ok"}, "attempts": 1, "failures": 0, "startedAt": 1756853482268, "compensate": {"state": "dormant", "status": "idle"}, "definition": {"uuid": "01K469C7NBAGB5B2E9YE6N73AK", "action": "authorize-payment-session-step", "noCompensation": false}, "stepFailed": false, "lastAttempt": 1756853482268, "saveResponse": true}, "_root.acquire-lock-step.use-query-graph-step.cart-query.validate-cart-payments.compensate-payment-if-needed.validate.shipping-options-query.validate-shipping.create-orders.emit-event-step.beforePaymentAuthorization.authorize-payment-session-step.add-order-transaction": {"id": "_root.acquire-lock-step.use-query-graph-step.cart-query.validate-cart-payments.compensate-payment-if-needed.validate.shipping-options-query.validate-shipping.create-orders.emit-event-step.beforePaymentAuthorization.authorize-payment-session-step.add-order-transaction", "next": ["_root.acquire-lock-step.use-query-graph-step.cart-query.validate-cart-payments.compensate-payment-if-needed.validate.shipping-options-query.validate-shipping.create-orders.emit-event-step.beforePaymentAuthorization.authorize-payment-session-step.add-order-transaction.orderCreated"], "uuid": "01K469C7NB4QVS6NFDDQ0DN2Z0", "depth": 13, "invoke": {"state": "done", "status": "ok"}, "attempts": 1, "failures": 0, "startedAt": 1756853482308, "compensate": {"state": "dormant", "status": "idle"}, "definition": {"uuid": "01K469C7NB4QVS6NFDDQ0DN2Z0", "action": "add-order-transaction", "noCompensation": false}, "stepFailed": false, "lastAttempt": 1756853482308, "saveResponse": true}, "_root.acquire-lock-step.use-query-graph-step.cart-query.validate-cart-payments.compensate-payment-if-needed.validate.shipping-options-query.validate-shipping.create-orders.emit-event-step.beforePaymentAuthorization.authorize-payment-session-step.add-order-transaction.orderCreated": {"id": "_root.acquire-lock-step.use-query-graph-step.cart-query.validate-cart-payments.compensate-payment-if-needed.validate.shipping-options-query.validate-shipping.create-orders.emit-event-step.beforePaymentAuthorization.authorize-payment-session-step.add-order-transaction.orderCreated", "next": ["_root.acquire-lock-step.use-query-graph-step.cart-query.validate-cart-payments.compensate-payment-if-needed.validate.shipping-options-query.validate-shipping.create-orders.emit-event-step.beforePaymentAuthorization.authorize-payment-session-step.add-order-transaction.orderCreated.create-order"], "uuid": "01K469C7NBBP3H66MH05RDFXG7", "depth": 14, "invoke": {"state": "done", "status": "ok"}, "attempts": 1, "failures": 0, "startedAt": 1756853482316, "compensate": {"state": "dormant", "status": "idle"}, "definition": {"uuid": "01K469C7NBBP3H66MH05RDFXG7", "action": "orderCreated", "noCompensation": false}, "stepFailed": false, "lastAttempt": 1756853482316, "saveResponse": true}, "_root.acquire-lock-step.use-query-graph-step.cart-query.validate-cart-payments.compensate-payment-if-needed.validate.shipping-options-query.validate-shipping.create-orders.emit-event-step.beforePaymentAuthorization.authorize-payment-session-step.add-order-transaction.orderCreated.create-order": {"id": "_root.acquire-lock-step.use-query-graph-step.cart-query.validate-cart-payments.compensate-payment-if-needed.validate.shipping-options-query.validate-shipping.create-orders.emit-event-step.beforePaymentAuthorization.authorize-payment-session-step.add-order-transaction.orderCreated.create-order", "next": ["_root.acquire-lock-step.use-query-graph-step.cart-query.validate-cart-payments.compensate-payment-if-needed.validate.shipping-options-query.validate-shipping.create-orders.emit-event-step.beforePaymentAuthorization.authorize-payment-session-step.add-order-transaction.orderCreated.create-order.release-lock-step"], "uuid": "01K469C7NB4FNTSQ51HGM1027Z", "depth": 15, "invoke": {"state": "done", "status": "ok"}, "attempts": 1, "failures": 0, "startedAt": 1756853482324, "compensate": {"state": "dormant", "status": "idle"}, "definition": {"uuid": "01K469C7NB4FNTSQ51HGM1027Z", "action": "create-order", "noCompensation": true}, "stepFailed": false, "lastAttempt": 1756853482324, "saveResponse": true}, "_root.acquire-lock-step.use-query-graph-step.cart-query.validate-cart-payments.compensate-payment-if-needed.validate.shipping-options-query.validate-shipping.create-orders.emit-event-step.beforePaymentAuthorization.authorize-payment-session-step.add-order-transaction.orderCreated.create-order.release-lock-step": {"id": "_root.acquire-lock-step.use-query-graph-step.cart-query.validate-cart-payments.compensate-payment-if-needed.validate.shipping-options-query.validate-shipping.create-orders.emit-event-step.beforePaymentAuthorization.authorize-payment-session-step.add-order-transaction.orderCreated.create-order.release-lock-step", "next": [], "uuid": "01K469C7NBWHHWY7HM8K4H50F1", "depth": 16, "invoke": {"state": "done", "status": "ok"}, "attempts": 1, "failures": 0, "startedAt": 1756853482334, "compensate": {"state": "dormant", "status": "idle"}, "definition": {"uuid": "01K469C7NBWHHWY7HM8K4H50F1", "action": "release-lock-step", "noCompensation": true}, "stepFailed": false, "lastAttempt": 1756853482334, "saveResponse": true}}, "modelId": "complete-cart", "options": {"name": "complete-cart", "store": true, "idempotent": false, "retentionTime": 259200}, "metadata": {"sourcePath": "/Users/mukul/Documents/GitHub/pharmint-marketplace/backend/node_modules/@medusajs/core-flows/dist/cart/workflows/complete-cart.js", "eventGroupId": "01K46A1CG5QCSPVDCVK1ZJ99BW"}, "startedAt": 1756853481999, "definition": {"next": {"next": {"next": {"next": {"next": {"next": {"next": {"next": {"next": [{"uuid": "01K469C7NBA28SPGPP6Y106KP3", "action": "create-remote-links", "noCompensation": false}, {"uuid": "01K469C7NB1MDEMDE6H0T395XE", "action": "update-carts", "noCompensation": false}, {"uuid": "01K469C7NBFMPYXH332EK3M0XY", "action": "reserve-inventory-step", "noCompensation": false}, {"uuid": "01K469C7NBADY8DSRRAZSBZNYE", "action": "register-usage", "noCompensation": false}, {"next": {"next": {"next": {"next": {"next": {"next": {"uuid": "01K469C7NBWHHWY7HM8K4H50F1", "action": "release-lock-step", "noCompensation": true}, "uuid": "01K469C7NB4FNTSQ51HGM1027Z", "action": "create-order", "noCompensation": true}, "uuid": "01K469C7NBBP3H66MH05RDFXG7", "action": "orderCreated", "noCompensation": false}, "uuid": "01K469C7NB4QVS6NFDDQ0DN2Z0", "action": "add-order-transaction", "noCompensation": false}, "uuid": "01K469C7NBAGB5B2E9YE6N73AK", "action": "authorize-payment-session-step", "noCompensation": false}, "uuid": "01K469C7NBV3YEQXNR3DTSHJG4", "action": "beforePaymentAuthorization", "noCompensation": false}, "uuid": "01K469C7NB2BXBC20K8B9XY14E", "action": "emit-event-step", "noCompensation": false}], "uuid": "01K469C7NA8GH0WCZ7WFHTDBSR", "action": "create-orders", "noCompensation": false}, "uuid": "01K469C7NAZT6EGHN1BDZHMD5E", "action": "validate-shipping", "noCompensation": true}, "uuid": "01K469C7NA4D327ZN0C6R8WVFF", "async": false, "action": "shipping-options-query", "noCompensation": true, "compensateAsync": false}, "uuid": "01K469C7NABP2XFS7294VH70PV", "action": "validate", "noCompensation": false}, "uuid": "01K469C7NARPX5YA98BGKSE44V", "action": "compensate-payment-if-needed", "noCompensation": false}, "uuid": "01K469C7NAJ7SE00HXZ57WMM3S", "action": "validate-cart-payments", "noCompensation": true}, "uuid": "01K469C7NA2KJ693P3WT423CSN", "async": false, "action": "cart-query", "noCompensation": true, "compensateAsync": false}, "uuid": "01K469C7NAJY5NVA5TX7Y57K7Q", "action": "use-query-graph-step", "noCompensation": true}, "uuid": "01K469C7NA5PA00VW0HZ800ZYV", "action": "acquire-lock-step", "noCompensation": false}, "timedOutAt": null, "hasAsyncSteps": false, "transactionId": "cart_01K466AXHFNSF95BC7REXFZ8B0", "hasFailedSteps": false, "hasSkippedSteps": false, "hasWaitingSteps": false, "hasRevertedSteps": false, "hasSkippedOnFailureSteps": false}	{"data": {"invoke": {"validate": {"__type": "Symbol(WorkflowWorkflowData)", "output": {"__type": "Symbol(WorkflowStepResponse)", "compensateInput": null}}, "cart-query": {"__type": "Symbol(WorkflowWorkflowData)", "output": {"__type": "Symbol(WorkflowStepResponse)", "output": {"id": "cart_01K466AXHFNSF95BC7REXFZ8B0", "email": "mk@mk.com", "items": [{"id": "cali_01K468ECQFE8SQKS9467B5AD66", "title": "Medusa T-Shirt", "total": 10, "cart_id": "cart_01K466AXHFNSF95BC7REXFZ8B0", "variant": {"id": "variant_01K465NX36QVW4VT9ZBR1WEYPA", "product": {"id": "prod_01K465NX26VFWW6C9Y3GJN3K6V", "is_giftcard": false, "shipping_profile": {"id": "sp_01K465NSMNCMB3KTQC20148JAW"}}, "product_id": "prod_01K465NX26VFWW6C9Y3GJN3K6V", "allow_backorder": false, "inventory_items": [{"inventory": {"id": "iitem_01K465NX3KN80Z3BCCYJFH27BP", "location_levels": [{"location_id": "sloc_01K465NX02PRA37GR065XPNVC1", "stock_locations": [{"id": "sloc_01K465NX02PRA37GR065XPNVC1", "name": "European Warehouse", "sales_channels": [{"id": "sc_01K465NVAAFMSJ0RGP5VCKEPVH", "name": "Default Sales Channel"}]}], "stocked_quantity": 1000000, "reserved_quantity": 0, "raw_stocked_quantity": {"value": "1000000", "precision": 20}, "raw_reserved_quantity": {"value": "0", "precision": 20}}], "requires_shipping": true}, "variant_id": "variant_01K465NX36QVW4VT9ZBR1WEYPA", "inventory_item_id": "iitem_01K465NX3KN80Z3BCCYJFH27BP", "required_quantity": 1}], "manage_inventory": true}, "metadata": {}, "quantity": 1, "subtitle": "M / Black", "subtotal": 10, "raw_total": {"value": "10", "precision": 20}, "tax_lines": [], "tax_total": 0, "thumbnail": "https://medusa-public-images.s3.eu-west-1.amazonaws.com/tee-black-front.png", "created_at": "2025-09-02T22:23:31.055Z", "deleted_at": null, "product_id": "prod_01K465NX26VFWW6C9Y3GJN3K6V", "unit_price": 10, "updated_at": "2025-09-02T22:23:31.055Z", "variant_id": "variant_01K465NX36QVW4VT9ZBR1WEYPA", "adjustments": [], "is_giftcard": false, "variant_sku": "SHIRT-M-BLACK", "product_type": null, "raw_subtotal": {"value": "10", "precision": 20}, "product_title": "Medusa T-Shirt", "raw_tax_total": {"value": "0", "precision": 20}, "variant_title": "M / Black", "discount_total": 0, "original_total": 10, "product_handle": "t-shirt", "raw_unit_price": {"value": "10", "precision": 20}, "is_custom_price": false, "is_discountable": true, "product_type_id": null, "variant_barcode": null, "is_tax_inclusive": false, "product_subtitle": null, "discount_subtotal": 0, "requires_shipping": true, "discount_tax_total": 0, "original_tax_total": 0, "product_collection": null, "raw_discount_total": {"value": "0", "precision": 20}, "raw_original_total": {"value": "10", "precision": 20}, "product_description": "Reimagine the feeling of a classic T-shirt. With our cotton T-shirts, everyday essentials no longer have to be ordinary.", "compare_at_unit_price": null, "raw_discount_subtotal": {"value": "0", "precision": 20}, "variant_option_values": null, "raw_discount_tax_total": {"value": "0", "precision": 20}, "raw_original_tax_total": {"value": "0", "precision": 20}, "raw_compare_at_unit_price": null}], "total": 20, "region": {"id": "reg_01K465NWZBB589QBS334WRK4PF", "name": "Europe", "metadata": null, "created_at": "2025-09-02T21:35:11.341Z", "deleted_at": null, "updated_at": "2025-09-02T21:35:11.341Z", "currency_code": "eur", "automatic_taxes": true}, "customer": {"id": "cus_01K46A0ZPRWKCSMQAW51DY0W8R", "email": "mk@mk.com", "phone": null, "metadata": null, "last_name": null, "created_at": "2025-09-02T22:51:08.888Z", "created_by": null, "deleted_at": null, "first_name": null, "updated_at": "2025-09-02T22:51:08.888Z", "has_account": false, "company_name": null}, "metadata": null, "subtotal": 20, "raw_total": {"value": "20", "precision": 20}, "region_id": "reg_01K465NWZBB589QBS334WRK4PF", "tax_total": 0, "created_at": "2025-09-02T21:46:40.049Z", "item_total": 10, "promotions": [], "updated_at": "2025-09-02T22:51:08.950Z", "customer_id": "cus_01K46A0ZPRWKCSMQAW51DY0W8R", "completed_at": null, "credit_lines": [], "raw_subtotal": {"value": "20", "precision": 20}, "currency_code": "eur", "item_subtotal": 10, "raw_tax_total": {"value": "0", "precision": 20}, "discount_total": 0, "item_tax_total": 0, "original_total": 20, "raw_item_total": {"value": "10", "precision": 20}, "shipping_total": 10, "billing_address": {"id": "caaddr_01K46A0ZRNDP5GCBE11PQBKJWC", "city": "varanasi", "phone": "", "company": "", "metadata": null, "province": "up", "address_1": "test", "address_2": "", "last_name": "test", "created_at": "2025-09-02T22:51:08.950Z", "deleted_at": null, "first_name": "test", "updated_at": "2025-09-02T22:51:08.950Z", "customer_id": null, "postal_code": "221002", "country_code": "it"}, "sales_channel_id": "sc_01K465NVAAFMSJ0RGP5VCKEPVH", "shipping_address": {"id": "caaddr_01K46A0ZRNPRJP2YKVVCX2RH5W", "city": "varanasi", "phone": "", "company": "", "metadata": null, "province": "up", "address_1": "test", "address_2": "", "last_name": "test", "created_at": "2025-09-02T22:51:08.950Z", "deleted_at": null, "first_name": "test", "updated_at": "2025-09-02T22:51:08.950Z", "customer_id": null, "postal_code": "221002", "country_code": "it"}, "shipping_methods": [{"id": "casm_01K46A12WMTEF0WW2GPAESHJ3N", "data": {}, "name": "Standard Shipping", "total": 10, "amount": 10, "cart_id": "cart_01K466AXHFNSF95BC7REXFZ8B0", "metadata": null, "subtotal": 10, "raw_total": {"value": "10", "precision": 20}, "tax_lines": [], "tax_total": 0, "created_at": "2025-09-02T22:51:12.148Z", "deleted_at": null, "raw_amount": {"value": "10", "precision": 20}, "updated_at": "2025-09-02T22:51:12.148Z", "adjustments": [], "description": null, "raw_subtotal": {"value": "10", "precision": 20}, "raw_tax_total": {"value": "0", "precision": 20}, "discount_total": 0, "original_total": 10, "is_tax_inclusive": false, "discount_subtotal": 0, "discount_tax_total": 0, "original_tax_total": 0, "raw_discount_total": {"value": "0", "precision": 20}, "raw_original_total": {"value": "10", "precision": 20}, "shipping_option_id": "so_01K465NX0W8FHES8P37CAFHZS3", "raw_discount_subtotal": {"value": "0", "precision": 20}, "raw_discount_tax_total": {"value": "0", "precision": 20}, "raw_original_tax_total": {"value": "0", "precision": 20}}], "raw_item_subtotal": {"value": "10", "precision": 20}, "shipping_subtotal": 10, "discount_tax_total": 0, "original_tax_total": 0, "payment_collection": {"id": "pay_col_01K46A16VZNY85A3HR7P2TGF0T", "amount": 20, "status": "not_paid", "metadata": null, "created_at": "2025-09-02T22:51:16.223Z", "deleted_at": null, "raw_amount": {"value": "20", "precision": 20}, "updated_at": "2025-09-02T22:51:16.223Z", "completed_at": null, "currency_code": "eur", "captured_amount": null, "refunded_amount": null, "payment_sessions": [{"id": "payses_01K46A16XPB4BJCMEGG737HHER", "data": {}, "amount": 20, "status": "pending", "context": {}, "metadata": {}, "created_at": "2025-09-02T22:51:16.278Z", "deleted_at": null, "raw_amount": {"value": "20", "precision": 20}, "updated_at": "2025-09-02T22:51:16.278Z", "provider_id": "pp_system_default", "authorized_at": null, "currency_code": "eur", "payment_collection_id": "pay_col_01K46A16VZNY85A3HR7P2TGF0T"}], "authorized_amount": null, "raw_captured_amount": null, "raw_refunded_amount": null, "raw_authorized_amount": null}, "raw_discount_total": {"value": "0", "precision": 20}, "raw_item_tax_total": {"value": "0", "precision": 20}, "raw_original_total": {"value": "20", "precision": 20}, "raw_shipping_total": {"value": "10", "precision": 20}, "shipping_tax_total": 0, "original_item_total": 10, "raw_shipping_subtotal": {"value": "10", "precision": 20}, "original_item_subtotal": 10, "raw_discount_tax_total": {"value": "0", "precision": 20}, "raw_original_tax_total": {"value": "0", "precision": 20}, "raw_shipping_tax_total": {"value": "0", "precision": 20}, "original_item_tax_total": 0, "original_shipping_total": 10, "raw_original_item_total": {"value": "10", "precision": 20}, "original_shipping_subtotal": 10, "raw_original_item_subtotal": {"value": "10", "precision": 20}, "original_shipping_tax_total": 0, "raw_original_item_tax_total": {"value": "0", "precision": 20}, "raw_original_shipping_total": {"value": "10", "precision": 20}, "raw_original_shipping_subtotal": {"value": "10", "precision": 20}, "raw_original_shipping_tax_total": {"value": "0", "precision": 20}}, "compensateInput": {"id": "cart_01K466AXHFNSF95BC7REXFZ8B0", "email": "mk@mk.com", "items": [{"id": "cali_01K468ECQFE8SQKS9467B5AD66", "title": "Medusa T-Shirt", "total": 10, "cart_id": "cart_01K466AXHFNSF95BC7REXFZ8B0", "variant": {"id": "variant_01K465NX36QVW4VT9ZBR1WEYPA", "product": {"id": "prod_01K465NX26VFWW6C9Y3GJN3K6V", "is_giftcard": false, "shipping_profile": {"id": "sp_01K465NSMNCMB3KTQC20148JAW"}}, "product_id": "prod_01K465NX26VFWW6C9Y3GJN3K6V", "allow_backorder": false, "inventory_items": [{"inventory": {"id": "iitem_01K465NX3KN80Z3BCCYJFH27BP", "location_levels": [{"location_id": "sloc_01K465NX02PRA37GR065XPNVC1", "stock_locations": [{"id": "sloc_01K465NX02PRA37GR065XPNVC1", "name": "European Warehouse", "sales_channels": [{"id": "sc_01K465NVAAFMSJ0RGP5VCKEPVH", "name": "Default Sales Channel"}]}], "stocked_quantity": 1000000, "reserved_quantity": 0, "raw_stocked_quantity": {"value": "1000000", "precision": 20}, "raw_reserved_quantity": {"value": "0", "precision": 20}}], "requires_shipping": true}, "variant_id": "variant_01K465NX36QVW4VT9ZBR1WEYPA", "inventory_item_id": "iitem_01K465NX3KN80Z3BCCYJFH27BP", "required_quantity": 1}], "manage_inventory": true}, "metadata": {}, "quantity": 1, "subtitle": "M / Black", "subtotal": 10, "raw_total": {"value": "10", "precision": 20}, "tax_lines": [], "tax_total": 0, "thumbnail": "https://medusa-public-images.s3.eu-west-1.amazonaws.com/tee-black-front.png", "created_at": "2025-09-02T22:23:31.055Z", "deleted_at": null, "product_id": "prod_01K465NX26VFWW6C9Y3GJN3K6V", "unit_price": 10, "updated_at": "2025-09-02T22:23:31.055Z", "variant_id": "variant_01K465NX36QVW4VT9ZBR1WEYPA", "adjustments": [], "is_giftcard": false, "variant_sku": "SHIRT-M-BLACK", "product_type": null, "raw_subtotal": {"value": "10", "precision": 20}, "product_title": "Medusa T-Shirt", "raw_tax_total": {"value": "0", "precision": 20}, "variant_title": "M / Black", "discount_total": 0, "original_total": 10, "product_handle": "t-shirt", "raw_unit_price": {"value": "10", "precision": 20}, "is_custom_price": false, "is_discountable": true, "product_type_id": null, "variant_barcode": null, "is_tax_inclusive": false, "product_subtitle": null, "discount_subtotal": 0, "requires_shipping": true, "discount_tax_total": 0, "original_tax_total": 0, "product_collection": null, "raw_discount_total": {"value": "0", "precision": 20}, "raw_original_total": {"value": "10", "precision": 20}, "product_description": "Reimagine the feeling of a classic T-shirt. With our cotton T-shirts, everyday essentials no longer have to be ordinary.", "compare_at_unit_price": null, "raw_discount_subtotal": {"value": "0", "precision": 20}, "variant_option_values": null, "raw_discount_tax_total": {"value": "0", "precision": 20}, "raw_original_tax_total": {"value": "0", "precision": 20}, "raw_compare_at_unit_price": null}], "total": 20, "region": {"id": "reg_01K465NWZBB589QBS334WRK4PF", "name": "Europe", "metadata": null, "created_at": "2025-09-02T21:35:11.341Z", "deleted_at": null, "updated_at": "2025-09-02T21:35:11.341Z", "currency_code": "eur", "automatic_taxes": true}, "customer": {"id": "cus_01K46A0ZPRWKCSMQAW51DY0W8R", "email": "mk@mk.com", "phone": null, "metadata": null, "last_name": null, "created_at": "2025-09-02T22:51:08.888Z", "created_by": null, "deleted_at": null, "first_name": null, "updated_at": "2025-09-02T22:51:08.888Z", "has_account": false, "company_name": null}, "metadata": null, "subtotal": 20, "raw_total": {"value": "20", "precision": 20}, "region_id": "reg_01K465NWZBB589QBS334WRK4PF", "tax_total": 0, "created_at": "2025-09-02T21:46:40.049Z", "item_total": 10, "promotions": [], "updated_at": "2025-09-02T22:51:08.950Z", "customer_id": "cus_01K46A0ZPRWKCSMQAW51DY0W8R", "completed_at": null, "credit_lines": [], "raw_subtotal": {"value": "20", "precision": 20}, "currency_code": "eur", "item_subtotal": 10, "raw_tax_total": {"value": "0", "precision": 20}, "discount_total": 0, "item_tax_total": 0, "original_total": 20, "raw_item_total": {"value": "10", "precision": 20}, "shipping_total": 10, "billing_address": {"id": "caaddr_01K46A0ZRNDP5GCBE11PQBKJWC", "city": "varanasi", "phone": "", "company": "", "metadata": null, "province": "up", "address_1": "test", "address_2": "", "last_name": "test", "created_at": "2025-09-02T22:51:08.950Z", "deleted_at": null, "first_name": "test", "updated_at": "2025-09-02T22:51:08.950Z", "customer_id": null, "postal_code": "221002", "country_code": "it"}, "sales_channel_id": "sc_01K465NVAAFMSJ0RGP5VCKEPVH", "shipping_address": {"id": "caaddr_01K46A0ZRNPRJP2YKVVCX2RH5W", "city": "varanasi", "phone": "", "company": "", "metadata": null, "province": "up", "address_1": "test", "address_2": "", "last_name": "test", "created_at": "2025-09-02T22:51:08.950Z", "deleted_at": null, "first_name": "test", "updated_at": "2025-09-02T22:51:08.950Z", "customer_id": null, "postal_code": "221002", "country_code": "it"}, "shipping_methods": [{"id": "casm_01K46A12WMTEF0WW2GPAESHJ3N", "data": {}, "name": "Standard Shipping", "total": 10, "amount": 10, "cart_id": "cart_01K466AXHFNSF95BC7REXFZ8B0", "metadata": null, "subtotal": 10, "raw_total": {"value": "10", "precision": 20}, "tax_lines": [], "tax_total": 0, "created_at": "2025-09-02T22:51:12.148Z", "deleted_at": null, "raw_amount": {"value": "10", "precision": 20}, "updated_at": "2025-09-02T22:51:12.148Z", "adjustments": [], "description": null, "raw_subtotal": {"value": "10", "precision": 20}, "raw_tax_total": {"value": "0", "precision": 20}, "discount_total": 0, "original_total": 10, "is_tax_inclusive": false, "discount_subtotal": 0, "discount_tax_total": 0, "original_tax_total": 0, "raw_discount_total": {"value": "0", "precision": 20}, "raw_original_total": {"value": "10", "precision": 20}, "shipping_option_id": "so_01K465NX0W8FHES8P37CAFHZS3", "raw_discount_subtotal": {"value": "0", "precision": 20}, "raw_discount_tax_total": {"value": "0", "precision": 20}, "raw_original_tax_total": {"value": "0", "precision": 20}}], "raw_item_subtotal": {"value": "10", "precision": 20}, "shipping_subtotal": 10, "discount_tax_total": 0, "original_tax_total": 0, "payment_collection": {"id": "pay_col_01K46A16VZNY85A3HR7P2TGF0T", "amount": 20, "status": "not_paid", "metadata": null, "created_at": "2025-09-02T22:51:16.223Z", "deleted_at": null, "raw_amount": {"value": "20", "precision": 20}, "updated_at": "2025-09-02T22:51:16.223Z", "completed_at": null, "currency_code": "eur", "captured_amount": null, "refunded_amount": null, "payment_sessions": [{"id": "payses_01K46A16XPB4BJCMEGG737HHER", "data": {}, "amount": 20, "status": "pending", "context": {}, "metadata": {}, "created_at": "2025-09-02T22:51:16.278Z", "deleted_at": null, "raw_amount": {"value": "20", "precision": 20}, "updated_at": "2025-09-02T22:51:16.278Z", "provider_id": "pp_system_default", "authorized_at": null, "currency_code": "eur", "payment_collection_id": "pay_col_01K46A16VZNY85A3HR7P2TGF0T"}], "authorized_amount": null, "raw_captured_amount": null, "raw_refunded_amount": null, "raw_authorized_amount": null}, "raw_discount_total": {"value": "0", "precision": 20}, "raw_item_tax_total": {"value": "0", "precision": 20}, "raw_original_total": {"value": "20", "precision": 20}, "raw_shipping_total": {"value": "10", "precision": 20}, "shipping_tax_total": 0, "original_item_total": 10, "raw_shipping_subtotal": {"value": "10", "precision": 20}, "original_item_subtotal": 10, "raw_discount_tax_total": {"value": "0", "precision": 20}, "raw_original_tax_total": {"value": "0", "precision": 20}, "raw_shipping_tax_total": {"value": "0", "precision": 20}, "original_item_tax_total": 0, "original_shipping_total": 10, "raw_original_item_total": {"value": "10", "precision": 20}, "original_shipping_subtotal": 10, "raw_original_item_subtotal": {"value": "10", "precision": 20}, "original_shipping_tax_total": 0, "raw_original_item_tax_total": {"value": "0", "precision": 20}, "raw_original_shipping_total": {"value": "10", "precision": 20}, "raw_original_shipping_subtotal": {"value": "10", "precision": 20}, "raw_original_shipping_tax_total": {"value": "0", "precision": 20}}}}, "create-order": {"__type": "Symbol(WorkflowWorkflowData)", "output": {"__type": "Symbol(WorkflowStepResponse)", "output": {"id": "order_01K46A1CNQR8DGVZ9N6RMYNSV5", "email": "mk@mk.com", "items": [{"id": "ordli_01K46A1CNQC8HHYQH4KJ54AGP4", "title": "Medusa T-Shirt", "detail": {"id": "orditem_01K46A1CNRDSB7SN2J8MTRH6NH", "item_id": "ordli_01K46A1CNQC8HHYQH4KJ54AGP4", "version": 1, "metadata": null, "order_id": "order_01K46A1CNQR8DGVZ9N6RMYNSV5", "quantity": 1, "created_at": "2025-09-02T22:51:22.169Z", "deleted_at": null, "unit_price": null, "updated_at": "2025-09-02T22:51:22.169Z", "raw_quantity": {"value": "1", "precision": 20}, "raw_unit_price": null, "shipped_quantity": 0, "delivered_quantity": 0, "fulfilled_quantity": 0, "raw_shipped_quantity": {"value": "0", "precision": 20}, "written_off_quantity": 0, "compare_at_unit_price": null, "raw_delivered_quantity": {"value": "0", "precision": 20}, "raw_fulfilled_quantity": {"value": "0", "precision": 20}, "raw_written_off_quantity": {"value": "0", "precision": 20}, "return_received_quantity": 0, "raw_compare_at_unit_price": null, "return_dismissed_quantity": 0, "return_requested_quantity": 0, "raw_return_received_quantity": {"value": "0", "precision": 20}, "raw_return_dismissed_quantity": {"value": "0", "precision": 20}, "raw_return_requested_quantity": {"value": "0", "precision": 20}}, "metadata": {}, "quantity": 1, "subtitle": "M / Black", "tax_lines": [], "thumbnail": "https://medusa-public-images.s3.eu-west-1.amazonaws.com/tee-black-front.png", "created_at": "2025-09-02T22:51:22.169Z", "deleted_at": null, "product_id": "prod_01K465NX26VFWW6C9Y3GJN3K6V", "unit_price": 10, "updated_at": "2025-09-02T22:51:22.169Z", "variant_id": "variant_01K465NX36QVW4VT9ZBR1WEYPA", "adjustments": [], "is_giftcard": false, "variant_sku": "SHIRT-M-BLACK", "product_type": null, "raw_quantity": {"value": "1", "precision": 20}, "product_title": "Medusa T-Shirt", "variant_title": "M / Black", "product_handle": "t-shirt", "raw_unit_price": {"value": "10", "precision": 20}, "is_custom_price": false, "is_discountable": true, "product_type_id": null, "variant_barcode": null, "is_tax_inclusive": false, "product_subtitle": null, "requires_shipping": true, "product_collection": null, "product_description": "Reimagine the feeling of a classic T-shirt. With our cotton T-shirts, everyday essentials no longer have to be ordinary.", "compare_at_unit_price": null, "variant_option_values": null, "raw_compare_at_unit_price": null}], "status": "pending", "summary": {"paid_total": 0, "raw_paid_total": {"value": "0", "precision": 20}, "refunded_total": 0, "accounting_total": 20, "credit_line_total": 0, "transaction_total": 0, "pending_difference": 20, "raw_refunded_total": {"value": "0", "precision": 20}, "current_order_total": 20, "original_order_total": 20, "raw_accounting_total": {"value": "20", "precision": 20}, "raw_credit_line_total": {"value": "0", "precision": 20}, "raw_transaction_total": {"value": "0", "precision": 20}, "raw_pending_difference": {"value": "20", "precision": 20}, "raw_current_order_total": {"value": "20", "precision": 20}, "raw_original_order_total": {"value": "20", "precision": 20}}, "version": 1, "metadata": null, "region_id": "reg_01K465NWZBB589QBS334WRK4PF", "created_at": "2025-09-02T22:51:22.169Z", "deleted_at": null, "display_id": 1, "updated_at": "2025-09-02T22:51:22.169Z", "canceled_at": null, "customer_id": "cus_01K46A0ZPRWKCSMQAW51DY0W8R", "credit_lines": [], "transactions": [], "currency_code": "eur", "is_draft_order": false, "billing_address": {"id": "ordaddr_01K46A1CNKR8AAC0SG2XMKJRNY", "city": "varanasi", "phone": "", "company": "", "metadata": null, "province": "up", "address_1": "test", "address_2": "", "last_name": "test", "created_at": "2025-09-02T22:51:08.950Z", "deleted_at": null, "first_name": "test", "updated_at": "2025-09-02T22:51:08.950Z", "customer_id": null, "postal_code": "221002", "country_code": "it"}, "no_notification": false, "sales_channel_id": "sc_01K465NVAAFMSJ0RGP5VCKEPVH", "shipping_address": {"id": "ordaddr_01K46A1CNKC3FAXGCPGK2CFN0G", "city": "varanasi", "phone": "", "company": "", "metadata": null, "province": "up", "address_1": "test", "address_2": "", "last_name": "test", "created_at": "2025-09-02T22:51:08.950Z", "deleted_at": null, "first_name": "test", "updated_at": "2025-09-02T22:51:08.950Z", "customer_id": null, "postal_code": "221002", "country_code": "it"}, "shipping_methods": [{"id": "ordsm_01K46A1CNPCCWDKAHX56BZ71W5", "data": {}, "name": "Standard Shipping", "amount": 10, "detail": {"id": "ordspmv_01K46A1CNPHSSRNNQ6R7D29J1D", "version": 1, "claim_id": null, "order_id": "order_01K46A1CNQR8DGVZ9N6RMYNSV5", "return_id": null, "created_at": "2025-09-02T22:51:22.169Z", "deleted_at": null, "updated_at": "2025-09-02T22:51:22.169Z", "exchange_id": null, "shipping_method_id": "ordsm_01K46A1CNPCCWDKAHX56BZ71W5"}, "metadata": null, "order_id": "order_01K46A1CNQR8DGVZ9N6RMYNSV5", "tax_lines": [], "created_at": "2025-09-02T22:51:22.169Z", "deleted_at": null, "raw_amount": {"value": "10", "precision": 20}, "updated_at": "2025-09-02T22:51:22.169Z", "adjustments": [], "description": null, "is_custom_amount": false, "is_tax_inclusive": false, "shipping_option_id": "so_01K465NX0W8FHES8P37CAFHZS3"}], "billing_address_id": "ordaddr_01K46A1CNKR8AAC0SG2XMKJRNY", "shipping_address_id": "ordaddr_01K46A1CNKC3FAXGCPGK2CFN0G"}, "compensateInput": {"id": "order_01K46A1CNQR8DGVZ9N6RMYNSV5", "email": "mk@mk.com", "items": [{"id": "ordli_01K46A1CNQC8HHYQH4KJ54AGP4", "title": "Medusa T-Shirt", "detail": {"id": "orditem_01K46A1CNRDSB7SN2J8MTRH6NH", "item_id": "ordli_01K46A1CNQC8HHYQH4KJ54AGP4", "version": 1, "metadata": null, "order_id": "order_01K46A1CNQR8DGVZ9N6RMYNSV5", "quantity": 1, "created_at": "2025-09-02T22:51:22.169Z", "deleted_at": null, "unit_price": null, "updated_at": "2025-09-02T22:51:22.169Z", "raw_quantity": {"value": "1", "precision": 20}, "raw_unit_price": null, "shipped_quantity": 0, "delivered_quantity": 0, "fulfilled_quantity": 0, "raw_shipped_quantity": {"value": "0", "precision": 20}, "written_off_quantity": 0, "compare_at_unit_price": null, "raw_delivered_quantity": {"value": "0", "precision": 20}, "raw_fulfilled_quantity": {"value": "0", "precision": 20}, "raw_written_off_quantity": {"value": "0", "precision": 20}, "return_received_quantity": 0, "raw_compare_at_unit_price": null, "return_dismissed_quantity": 0, "return_requested_quantity": 0, "raw_return_received_quantity": {"value": "0", "precision": 20}, "raw_return_dismissed_quantity": {"value": "0", "precision": 20}, "raw_return_requested_quantity": {"value": "0", "precision": 20}}, "metadata": {}, "quantity": 1, "subtitle": "M / Black", "tax_lines": [], "thumbnail": "https://medusa-public-images.s3.eu-west-1.amazonaws.com/tee-black-front.png", "created_at": "2025-09-02T22:51:22.169Z", "deleted_at": null, "product_id": "prod_01K465NX26VFWW6C9Y3GJN3K6V", "unit_price": 10, "updated_at": "2025-09-02T22:51:22.169Z", "variant_id": "variant_01K465NX36QVW4VT9ZBR1WEYPA", "adjustments": [], "is_giftcard": false, "variant_sku": "SHIRT-M-BLACK", "product_type": null, "raw_quantity": {"value": "1", "precision": 20}, "product_title": "Medusa T-Shirt", "variant_title": "M / Black", "product_handle": "t-shirt", "raw_unit_price": {"value": "10", "precision": 20}, "is_custom_price": false, "is_discountable": true, "product_type_id": null, "variant_barcode": null, "is_tax_inclusive": false, "product_subtitle": null, "requires_shipping": true, "product_collection": null, "product_description": "Reimagine the feeling of a classic T-shirt. With our cotton T-shirts, everyday essentials no longer have to be ordinary.", "compare_at_unit_price": null, "variant_option_values": null, "raw_compare_at_unit_price": null}], "status": "pending", "summary": {"paid_total": 0, "raw_paid_total": {"value": "0", "precision": 20}, "refunded_total": 0, "accounting_total": 20, "credit_line_total": 0, "transaction_total": 0, "pending_difference": 20, "raw_refunded_total": {"value": "0", "precision": 20}, "current_order_total": 20, "original_order_total": 20, "raw_accounting_total": {"value": "20", "precision": 20}, "raw_credit_line_total": {"value": "0", "precision": 20}, "raw_transaction_total": {"value": "0", "precision": 20}, "raw_pending_difference": {"value": "20", "precision": 20}, "raw_current_order_total": {"value": "20", "precision": 20}, "raw_original_order_total": {"value": "20", "precision": 20}}, "version": 1, "metadata": null, "region_id": "reg_01K465NWZBB589QBS334WRK4PF", "created_at": "2025-09-02T22:51:22.169Z", "deleted_at": null, "display_id": 1, "updated_at": "2025-09-02T22:51:22.169Z", "canceled_at": null, "customer_id": "cus_01K46A0ZPRWKCSMQAW51DY0W8R", "credit_lines": [], "transactions": [], "currency_code": "eur", "is_draft_order": false, "billing_address": {"id": "ordaddr_01K46A1CNKR8AAC0SG2XMKJRNY", "city": "varanasi", "phone": "", "company": "", "metadata": null, "province": "up", "address_1": "test", "address_2": "", "last_name": "test", "created_at": "2025-09-02T22:51:08.950Z", "deleted_at": null, "first_name": "test", "updated_at": "2025-09-02T22:51:08.950Z", "customer_id": null, "postal_code": "221002", "country_code": "it"}, "no_notification": false, "sales_channel_id": "sc_01K465NVAAFMSJ0RGP5VCKEPVH", "shipping_address": {"id": "ordaddr_01K46A1CNKC3FAXGCPGK2CFN0G", "city": "varanasi", "phone": "", "company": "", "metadata": null, "province": "up", "address_1": "test", "address_2": "", "last_name": "test", "created_at": "2025-09-02T22:51:08.950Z", "deleted_at": null, "first_name": "test", "updated_at": "2025-09-02T22:51:08.950Z", "customer_id": null, "postal_code": "221002", "country_code": "it"}, "shipping_methods": [{"id": "ordsm_01K46A1CNPCCWDKAHX56BZ71W5", "data": {}, "name": "Standard Shipping", "amount": 10, "detail": {"id": "ordspmv_01K46A1CNPHSSRNNQ6R7D29J1D", "version": 1, "claim_id": null, "order_id": "order_01K46A1CNQR8DGVZ9N6RMYNSV5", "return_id": null, "created_at": "2025-09-02T22:51:22.169Z", "deleted_at": null, "updated_at": "2025-09-02T22:51:22.169Z", "exchange_id": null, "shipping_method_id": "ordsm_01K46A1CNPCCWDKAHX56BZ71W5"}, "metadata": null, "order_id": "order_01K46A1CNQR8DGVZ9N6RMYNSV5", "tax_lines": [], "created_at": "2025-09-02T22:51:22.169Z", "deleted_at": null, "raw_amount": {"value": "10", "precision": 20}, "updated_at": "2025-09-02T22:51:22.169Z", "adjustments": [], "description": null, "is_custom_amount": false, "is_tax_inclusive": false, "shipping_option_id": "so_01K465NX0W8FHES8P37CAFHZS3"}], "billing_address_id": "ordaddr_01K46A1CNKR8AAC0SG2XMKJRNY", "shipping_address_id": "ordaddr_01K46A1CNKC3FAXGCPGK2CFN0G"}}}, "orderCreated": {"__type": "Symbol(WorkflowWorkflowData)", "output": {"__type": "Symbol(WorkflowStepResponse)"}}, "update-carts": {"__type": "Symbol(WorkflowWorkflowData)", "output": {"__type": "Symbol(WorkflowStepResponse)", "output": [{"id": "cart_01K466AXHFNSF95BC7REXFZ8B0", "email": "mk@mk.com", "metadata": null, "region_id": "reg_01K465NWZBB589QBS334WRK4PF", "created_at": "2025-09-02T21:46:40.049Z", "deleted_at": null, "updated_at": "2025-09-02T22:51:22.244Z", "customer_id": "cus_01K46A0ZPRWKCSMQAW51DY0W8R", "completed_at": "2025-09-02T22:51:22.235Z", "currency_code": "eur", "billing_address": {"id": "caaddr_01K46A0ZRNDP5GCBE11PQBKJWC"}, "sales_channel_id": "sc_01K465NVAAFMSJ0RGP5VCKEPVH", "shipping_address": {"id": "caaddr_01K46A0ZRNPRJP2YKVVCX2RH5W"}, "billing_address_id": "caaddr_01K46A0ZRNDP5GCBE11PQBKJWC", "shipping_address_id": "caaddr_01K46A0ZRNPRJP2YKVVCX2RH5W"}], "compensateInput": [{"id": "cart_01K466AXHFNSF95BC7REXFZ8B0", "email": "mk@mk.com", "metadata": null, "region_id": "reg_01K465NWZBB589QBS334WRK4PF", "customer_id": "cus_01K46A0ZPRWKCSMQAW51DY0W8R", "completed_at": null, "currency_code": "eur", "sales_channel_id": "sc_01K465NVAAFMSJ0RGP5VCKEPVH"}]}}, "create-orders": {"__type": "Symbol(WorkflowWorkflowData)", "output": {"__type": "Symbol(WorkflowStepResponse)", "output": [{"id": "order_01K46A1CNQR8DGVZ9N6RMYNSV5", "email": "mk@mk.com", "items": [{"id": "ordli_01K46A1CNQC8HHYQH4KJ54AGP4", "title": "Medusa T-Shirt", "detail": {"id": "orditem_01K46A1CNRDSB7SN2J8MTRH6NH", "item_id": "ordli_01K46A1CNQC8HHYQH4KJ54AGP4", "version": 1, "metadata": null, "order_id": "order_01K46A1CNQR8DGVZ9N6RMYNSV5", "quantity": 1, "created_at": "2025-09-02T22:51:22.169Z", "deleted_at": null, "unit_price": null, "updated_at": "2025-09-02T22:51:22.169Z", "raw_quantity": {"value": "1", "precision": 20}, "raw_unit_price": null, "shipped_quantity": 0, "delivered_quantity": 0, "fulfilled_quantity": 0, "raw_shipped_quantity": {"value": "0", "precision": 20}, "written_off_quantity": 0, "compare_at_unit_price": null, "raw_delivered_quantity": {"value": "0", "precision": 20}, "raw_fulfilled_quantity": {"value": "0", "precision": 20}, "raw_written_off_quantity": {"value": "0", "precision": 20}, "return_received_quantity": 0, "raw_compare_at_unit_price": null, "return_dismissed_quantity": 0, "return_requested_quantity": 0, "raw_return_received_quantity": {"value": "0", "precision": 20}, "raw_return_dismissed_quantity": {"value": "0", "precision": 20}, "raw_return_requested_quantity": {"value": "0", "precision": 20}}, "metadata": {}, "quantity": 1, "subtitle": "M / Black", "tax_lines": [], "thumbnail": "https://medusa-public-images.s3.eu-west-1.amazonaws.com/tee-black-front.png", "created_at": "2025-09-02T22:51:22.169Z", "deleted_at": null, "product_id": "prod_01K465NX26VFWW6C9Y3GJN3K6V", "unit_price": 10, "updated_at": "2025-09-02T22:51:22.169Z", "variant_id": "variant_01K465NX36QVW4VT9ZBR1WEYPA", "adjustments": [], "is_giftcard": false, "variant_sku": "SHIRT-M-BLACK", "product_type": null, "raw_quantity": {"value": "1", "precision": 20}, "product_title": "Medusa T-Shirt", "variant_title": "M / Black", "product_handle": "t-shirt", "raw_unit_price": {"value": "10", "precision": 20}, "is_custom_price": false, "is_discountable": true, "product_type_id": null, "variant_barcode": null, "is_tax_inclusive": false, "product_subtitle": null, "requires_shipping": true, "product_collection": null, "product_description": "Reimagine the feeling of a classic T-shirt. With our cotton T-shirts, everyday essentials no longer have to be ordinary.", "compare_at_unit_price": null, "variant_option_values": null, "raw_compare_at_unit_price": null}], "status": "pending", "summary": {"paid_total": 0, "raw_paid_total": {"value": "0", "precision": 20}, "refunded_total": 0, "accounting_total": 20, "credit_line_total": 0, "transaction_total": 0, "pending_difference": 20, "raw_refunded_total": {"value": "0", "precision": 20}, "current_order_total": 20, "original_order_total": 20, "raw_accounting_total": {"value": "20", "precision": 20}, "raw_credit_line_total": {"value": "0", "precision": 20}, "raw_transaction_total": {"value": "0", "precision": 20}, "raw_pending_difference": {"value": "20", "precision": 20}, "raw_current_order_total": {"value": "20", "precision": 20}, "raw_original_order_total": {"value": "20", "precision": 20}}, "version": 1, "metadata": null, "region_id": "reg_01K465NWZBB589QBS334WRK4PF", "created_at": "2025-09-02T22:51:22.169Z", "deleted_at": null, "display_id": 1, "updated_at": "2025-09-02T22:51:22.169Z", "canceled_at": null, "customer_id": "cus_01K46A0ZPRWKCSMQAW51DY0W8R", "credit_lines": [], "transactions": [], "currency_code": "eur", "is_draft_order": false, "billing_address": {"id": "ordaddr_01K46A1CNKR8AAC0SG2XMKJRNY", "city": "varanasi", "phone": "", "company": "", "metadata": null, "province": "up", "address_1": "test", "address_2": "", "last_name": "test", "created_at": "2025-09-02T22:51:08.950Z", "deleted_at": null, "first_name": "test", "updated_at": "2025-09-02T22:51:08.950Z", "customer_id": null, "postal_code": "221002", "country_code": "it"}, "no_notification": false, "sales_channel_id": "sc_01K465NVAAFMSJ0RGP5VCKEPVH", "shipping_address": {"id": "ordaddr_01K46A1CNKC3FAXGCPGK2CFN0G", "city": "varanasi", "phone": "", "company": "", "metadata": null, "province": "up", "address_1": "test", "address_2": "", "last_name": "test", "created_at": "2025-09-02T22:51:08.950Z", "deleted_at": null, "first_name": "test", "updated_at": "2025-09-02T22:51:08.950Z", "customer_id": null, "postal_code": "221002", "country_code": "it"}, "shipping_methods": [{"id": "ordsm_01K46A1CNPCCWDKAHX56BZ71W5", "data": {}, "name": "Standard Shipping", "amount": 10, "detail": {"id": "ordspmv_01K46A1CNPHSSRNNQ6R7D29J1D", "version": 1, "claim_id": null, "order_id": "order_01K46A1CNQR8DGVZ9N6RMYNSV5", "return_id": null, "created_at": "2025-09-02T22:51:22.169Z", "deleted_at": null, "updated_at": "2025-09-02T22:51:22.169Z", "exchange_id": null, "shipping_method_id": "ordsm_01K46A1CNPCCWDKAHX56BZ71W5"}, "metadata": null, "order_id": "order_01K46A1CNQR8DGVZ9N6RMYNSV5", "tax_lines": [], "created_at": "2025-09-02T22:51:22.169Z", "deleted_at": null, "raw_amount": {"value": "10", "precision": 20}, "updated_at": "2025-09-02T22:51:22.169Z", "adjustments": [], "description": null, "is_custom_amount": false, "is_tax_inclusive": false, "shipping_option_id": "so_01K465NX0W8FHES8P37CAFHZS3"}], "billing_address_id": "ordaddr_01K46A1CNKR8AAC0SG2XMKJRNY", "shipping_address_id": "ordaddr_01K46A1CNKC3FAXGCPGK2CFN0G"}], "compensateInput": ["order_01K46A1CNQR8DGVZ9N6RMYNSV5"]}}, "register-usage": {"__type": "Symbol(WorkflowWorkflowData)", "output": {"__type": "Symbol(WorkflowStepResponse)", "output": null, "compensateInput": []}}, "emit-event-step": {"__type": "Symbol(WorkflowWorkflowData)", "output": {"__type": "Symbol(WorkflowStepResponse)", "output": {"eventName": "order.placed", "eventGroupId": "01K46A1CG5QCSPVDCVK1ZJ99BW"}, "compensateInput": {"eventName": "order.placed", "eventGroupId": "01K46A1CG5QCSPVDCVK1ZJ99BW"}}}, "acquire-lock-step": {"__type": "Symbol(WorkflowWorkflowData)", "output": {"__type": "Symbol(WorkflowStepResponse)", "compensateInput": {"keys": ["cart_01K466AXHFNSF95BC7REXFZ8B0"]}}}, "release-lock-step": {"__type": "Symbol(WorkflowWorkflowData)", "output": {"__type": "Symbol(WorkflowStepResponse)", "output": true, "compensateInput": true}}, "validate-shipping": {"__type": "Symbol(WorkflowWorkflowData)", "output": {"__type": "Symbol(WorkflowStepResponse)"}}, "create-remote-links": {"__type": "Symbol(WorkflowWorkflowData)", "output": {"__type": "Symbol(WorkflowStepResponse)", "output": [{"cart": {"cart_id": "cart_01K466AXHFNSF95BC7REXFZ8B0"}, "order": {"order_id": "order_01K46A1CNQR8DGVZ9N6RMYNSV5"}}, {"order": {"order_id": "order_01K46A1CNQR8DGVZ9N6RMYNSV5"}, "payment": {"payment_collection_id": "pay_col_01K46A16VZNY85A3HR7P2TGF0T"}}], "compensateInput": [{"cart": {"cart_id": "cart_01K466AXHFNSF95BC7REXFZ8B0"}, "order": {"order_id": "order_01K46A1CNQR8DGVZ9N6RMYNSV5"}}, {"order": {"order_id": "order_01K46A1CNQR8DGVZ9N6RMYNSV5"}, "payment": {"payment_collection_id": "pay_col_01K46A16VZNY85A3HR7P2TGF0T"}}]}}, "use-query-graph-step": {"__type": "Symbol(WorkflowWorkflowData)", "output": {"__type": "Symbol(WorkflowStepResponse)", "output": {"data": []}, "compensateInput": {"data": []}}}, "add-order-transaction": {"__type": "Symbol(WorkflowWorkflowData)", "output": {"__type": "Symbol(WorkflowStepResponse)", "output": null, "compensateInput": null}}, "reserve-inventory-step": {"__type": "Symbol(WorkflowWorkflowData)", "output": {"__type": "Symbol(WorkflowStepResponse)", "output": [{"id": "resitem_01K46A1CR6YBS3PKSK2MT4SZA9", "metadata": null, "quantity": 1, "created_at": "2025-09-02T22:51:22.247Z", "created_by": null, "deleted_at": null, "updated_at": "2025-09-02T22:51:22.247Z", "description": null, "external_id": null, "location_id": "sloc_01K465NX02PRA37GR065XPNVC1", "line_item_id": "ordli_01K46A1CNQC8HHYQH4KJ54AGP4", "raw_quantity": {"value": "1", "precision": 20}, "allow_backorder": false, "inventory_item_id": "iitem_01K465NX3KN80Z3BCCYJFH27BP"}], "compensateInput": {"reservations": ["resitem_01K46A1CR6YBS3PKSK2MT4SZA9"], "inventoryItemIds": ["iitem_01K465NX3KN80Z3BCCYJFH27BP"]}}}, "shipping-options-query": {"__type": "Symbol(WorkflowWorkflowData)", "output": {"__type": "Symbol(WorkflowStepResponse)", "output": [{"id": "so_01K465NX0W8FHES8P37CAFHZS3", "shipping_profile_id": "sp_01K465NSMNCMB3KTQC20148JAW"}], "compensateInput": [{"id": "so_01K465NX0W8FHES8P37CAFHZS3", "shipping_profile_id": "sp_01K465NSMNCMB3KTQC20148JAW"}]}}, "validate-cart-payments": {"__type": "Symbol(WorkflowWorkflowData)", "output": {"__type": "Symbol(WorkflowStepResponse)", "output": [{"id": "payses_01K46A16XPB4BJCMEGG737HHER", "data": {}, "amount": 20, "status": "pending", "context": {}, "metadata": {}, "created_at": "2025-09-02T22:51:16.278Z", "deleted_at": null, "raw_amount": {"value": "20", "precision": 20}, "updated_at": "2025-09-02T22:51:16.278Z", "provider_id": "pp_system_default", "authorized_at": null, "currency_code": "eur", "payment_collection_id": "pay_col_01K46A16VZNY85A3HR7P2TGF0T"}], "compensateInput": [{"id": "payses_01K46A16XPB4BJCMEGG737HHER", "data": {}, "amount": 20, "status": "pending", "context": {}, "metadata": {}, "created_at": "2025-09-02T22:51:16.278Z", "deleted_at": null, "raw_amount": {"value": "20", "precision": 20}, "updated_at": "2025-09-02T22:51:16.278Z", "provider_id": "pp_system_default", "authorized_at": null, "currency_code": "eur", "payment_collection_id": "pay_col_01K46A16VZNY85A3HR7P2TGF0T"}]}}, "beforePaymentAuthorization": {"__type": "Symbol(WorkflowWorkflowData)", "output": {"__type": "Symbol(WorkflowStepResponse)"}}, "compensate-payment-if-needed": {"__type": "Symbol(WorkflowWorkflowData)", "output": {"__type": "Symbol(WorkflowStepResponse)", "output": "payses_01K46A16XPB4BJCMEGG737HHER", "compensateInput": "payses_01K46A16XPB4BJCMEGG737HHER"}}, "authorize-payment-session-step": {"__type": "Symbol(WorkflowWorkflowData)", "output": {"__type": "Symbol(WorkflowStepResponse)", "output": {"id": "pay_01K46A1CS3H2RF78M2C6RFHV9X", "data": {}, "amount": 20, "captures": [], "metadata": null, "created_at": "2025-09-02T22:51:22.275Z", "deleted_at": null, "raw_amount": {"value": "20", "precision": 20}, "updated_at": "2025-09-02T22:51:22.275Z", "canceled_at": null, "captured_at": null, "provider_id": "pp_system_default", "currency_code": "eur", "payment_collection": {"id": "pay_col_01K46A16VZNY85A3HR7P2TGF0T"}, "payment_session_id": "payses_01K46A16XPB4BJCMEGG737HHER", "payment_collection_id": "pay_col_01K46A16VZNY85A3HR7P2TGF0T"}, "compensateInput": {"id": "pay_01K46A1CS3H2RF78M2C6RFHV9X", "data": {}, "amount": 20, "captures": [], "metadata": null, "created_at": "2025-09-02T22:51:22.275Z", "deleted_at": null, "raw_amount": {"value": "20", "precision": 20}, "updated_at": "2025-09-02T22:51:22.275Z", "canceled_at": null, "captured_at": null, "provider_id": "pp_system_default", "currency_code": "eur", "payment_collection": {"id": "pay_col_01K46A16VZNY85A3HR7P2TGF0T"}, "payment_session_id": "payses_01K46A16XPB4BJCMEGG737HHER", "payment_collection_id": "pay_col_01K46A16VZNY85A3HR7P2TGF0T"}}}}, "payload": {"id": "cart_01K466AXHFNSF95BC7REXFZ8B0"}, "compensate": {}}, "errors": []}	done	2025-09-02 22:51:21.996	2025-09-02 22:51:22.344	\N	259200	01K46A1CG981BPHT37QNXGE1ME
\.


--
-- Name: link_module_migrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.link_module_migrations_id_seq', 18, true);


--
-- Name: mikro_orm_migrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.mikro_orm_migrations_id_seq', 117, true);


--
-- Name: order_change_action_ordering_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.order_change_action_ordering_seq', 3, true);


--
-- Name: order_claim_display_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.order_claim_display_id_seq', 1, false);


--
-- Name: order_display_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.order_display_id_seq', 1, true);


--
-- Name: order_exchange_display_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.order_exchange_display_id_seq', 1, false);


--
-- Name: return_display_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.return_display_id_seq', 1, false);


--
-- Name: script_migrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.script_migrations_id_seq', 2, true);


--
-- Name: account_holder account_holder_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.account_holder
    ADD CONSTRAINT account_holder_pkey PRIMARY KEY (id);


--
-- Name: api_key api_key_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.api_key
    ADD CONSTRAINT api_key_pkey PRIMARY KEY (id);


--
-- Name: application_method_buy_rules application_method_buy_rules_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.application_method_buy_rules
    ADD CONSTRAINT application_method_buy_rules_pkey PRIMARY KEY (application_method_id, promotion_rule_id);


--
-- Name: application_method_target_rules application_method_target_rules_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.application_method_target_rules
    ADD CONSTRAINT application_method_target_rules_pkey PRIMARY KEY (application_method_id, promotion_rule_id);


--
-- Name: auth_identity auth_identity_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_identity
    ADD CONSTRAINT auth_identity_pkey PRIMARY KEY (id);


--
-- Name: capture capture_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.capture
    ADD CONSTRAINT capture_pkey PRIMARY KEY (id);


--
-- Name: cart_address cart_address_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cart_address
    ADD CONSTRAINT cart_address_pkey PRIMARY KEY (id);


--
-- Name: cart_line_item_adjustment cart_line_item_adjustment_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cart_line_item_adjustment
    ADD CONSTRAINT cart_line_item_adjustment_pkey PRIMARY KEY (id);


--
-- Name: cart_line_item cart_line_item_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cart_line_item
    ADD CONSTRAINT cart_line_item_pkey PRIMARY KEY (id);


--
-- Name: cart_line_item_tax_line cart_line_item_tax_line_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cart_line_item_tax_line
    ADD CONSTRAINT cart_line_item_tax_line_pkey PRIMARY KEY (id);


--
-- Name: cart_payment_collection cart_payment_collection_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cart_payment_collection
    ADD CONSTRAINT cart_payment_collection_pkey PRIMARY KEY (cart_id, payment_collection_id);


--
-- Name: cart cart_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cart
    ADD CONSTRAINT cart_pkey PRIMARY KEY (id);


--
-- Name: cart_promotion cart_promotion_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cart_promotion
    ADD CONSTRAINT cart_promotion_pkey PRIMARY KEY (cart_id, promotion_id);


--
-- Name: cart_shipping_method_adjustment cart_shipping_method_adjustment_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cart_shipping_method_adjustment
    ADD CONSTRAINT cart_shipping_method_adjustment_pkey PRIMARY KEY (id);


--
-- Name: cart_shipping_method cart_shipping_method_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cart_shipping_method
    ADD CONSTRAINT cart_shipping_method_pkey PRIMARY KEY (id);


--
-- Name: cart_shipping_method_tax_line cart_shipping_method_tax_line_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cart_shipping_method_tax_line
    ADD CONSTRAINT cart_shipping_method_tax_line_pkey PRIMARY KEY (id);


--
-- Name: credit_line credit_line_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.credit_line
    ADD CONSTRAINT credit_line_pkey PRIMARY KEY (id);


--
-- Name: currency currency_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.currency
    ADD CONSTRAINT currency_pkey PRIMARY KEY (code);


--
-- Name: customer_account_holder customer_account_holder_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer_account_holder
    ADD CONSTRAINT customer_account_holder_pkey PRIMARY KEY (customer_id, account_holder_id);


--
-- Name: customer_address customer_address_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer_address
    ADD CONSTRAINT customer_address_pkey PRIMARY KEY (id);


--
-- Name: customer_group_customer customer_group_customer_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer_group_customer
    ADD CONSTRAINT customer_group_customer_pkey PRIMARY KEY (id);


--
-- Name: customer_group customer_group_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer_group
    ADD CONSTRAINT customer_group_pkey PRIMARY KEY (id);


--
-- Name: customer customer_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer
    ADD CONSTRAINT customer_pkey PRIMARY KEY (id);


--
-- Name: fulfillment_address fulfillment_address_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fulfillment_address
    ADD CONSTRAINT fulfillment_address_pkey PRIMARY KEY (id);


--
-- Name: fulfillment_item fulfillment_item_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fulfillment_item
    ADD CONSTRAINT fulfillment_item_pkey PRIMARY KEY (id);


--
-- Name: fulfillment_label fulfillment_label_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fulfillment_label
    ADD CONSTRAINT fulfillment_label_pkey PRIMARY KEY (id);


--
-- Name: fulfillment fulfillment_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fulfillment
    ADD CONSTRAINT fulfillment_pkey PRIMARY KEY (id);


--
-- Name: fulfillment_provider fulfillment_provider_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fulfillment_provider
    ADD CONSTRAINT fulfillment_provider_pkey PRIMARY KEY (id);


--
-- Name: fulfillment_set fulfillment_set_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fulfillment_set
    ADD CONSTRAINT fulfillment_set_pkey PRIMARY KEY (id);


--
-- Name: geo_zone geo_zone_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.geo_zone
    ADD CONSTRAINT geo_zone_pkey PRIMARY KEY (id);


--
-- Name: image image_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.image
    ADD CONSTRAINT image_pkey PRIMARY KEY (id);


--
-- Name: inventory_item inventory_item_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventory_item
    ADD CONSTRAINT inventory_item_pkey PRIMARY KEY (id);


--
-- Name: inventory_level inventory_level_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventory_level
    ADD CONSTRAINT inventory_level_pkey PRIMARY KEY (id);


--
-- Name: invite invite_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.invite
    ADD CONSTRAINT invite_pkey PRIMARY KEY (id);


--
-- Name: link_module_migrations link_module_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.link_module_migrations
    ADD CONSTRAINT link_module_migrations_pkey PRIMARY KEY (id);


--
-- Name: link_module_migrations link_module_migrations_table_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.link_module_migrations
    ADD CONSTRAINT link_module_migrations_table_name_key UNIQUE (table_name);


--
-- Name: location_fulfillment_provider location_fulfillment_provider_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.location_fulfillment_provider
    ADD CONSTRAINT location_fulfillment_provider_pkey PRIMARY KEY (stock_location_id, fulfillment_provider_id);


--
-- Name: location_fulfillment_set location_fulfillment_set_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.location_fulfillment_set
    ADD CONSTRAINT location_fulfillment_set_pkey PRIMARY KEY (stock_location_id, fulfillment_set_id);


--
-- Name: mikro_orm_migrations mikro_orm_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mikro_orm_migrations
    ADD CONSTRAINT mikro_orm_migrations_pkey PRIMARY KEY (id);


--
-- Name: notification notification_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notification
    ADD CONSTRAINT notification_pkey PRIMARY KEY (id);


--
-- Name: notification_provider notification_provider_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notification_provider
    ADD CONSTRAINT notification_provider_pkey PRIMARY KEY (id);


--
-- Name: order_address order_address_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_address
    ADD CONSTRAINT order_address_pkey PRIMARY KEY (id);


--
-- Name: order_cart order_cart_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_cart
    ADD CONSTRAINT order_cart_pkey PRIMARY KEY (order_id, cart_id);


--
-- Name: order_change_action order_change_action_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_change_action
    ADD CONSTRAINT order_change_action_pkey PRIMARY KEY (id);


--
-- Name: order_change order_change_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_change
    ADD CONSTRAINT order_change_pkey PRIMARY KEY (id);


--
-- Name: order_claim_item_image order_claim_item_image_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_claim_item_image
    ADD CONSTRAINT order_claim_item_image_pkey PRIMARY KEY (id);


--
-- Name: order_claim_item order_claim_item_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_claim_item
    ADD CONSTRAINT order_claim_item_pkey PRIMARY KEY (id);


--
-- Name: order_claim order_claim_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_claim
    ADD CONSTRAINT order_claim_pkey PRIMARY KEY (id);


--
-- Name: order_credit_line order_credit_line_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_credit_line
    ADD CONSTRAINT order_credit_line_pkey PRIMARY KEY (id);


--
-- Name: order_exchange_item order_exchange_item_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_exchange_item
    ADD CONSTRAINT order_exchange_item_pkey PRIMARY KEY (id);


--
-- Name: order_exchange order_exchange_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_exchange
    ADD CONSTRAINT order_exchange_pkey PRIMARY KEY (id);


--
-- Name: order_fulfillment order_fulfillment_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_fulfillment
    ADD CONSTRAINT order_fulfillment_pkey PRIMARY KEY (order_id, fulfillment_id);


--
-- Name: order_item order_item_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_item
    ADD CONSTRAINT order_item_pkey PRIMARY KEY (id);


--
-- Name: order_line_item_adjustment order_line_item_adjustment_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_line_item_adjustment
    ADD CONSTRAINT order_line_item_adjustment_pkey PRIMARY KEY (id);


--
-- Name: order_line_item order_line_item_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_line_item
    ADD CONSTRAINT order_line_item_pkey PRIMARY KEY (id);


--
-- Name: order_line_item_tax_line order_line_item_tax_line_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_line_item_tax_line
    ADD CONSTRAINT order_line_item_tax_line_pkey PRIMARY KEY (id);


--
-- Name: order_payment_collection order_payment_collection_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_payment_collection
    ADD CONSTRAINT order_payment_collection_pkey PRIMARY KEY (order_id, payment_collection_id);


--
-- Name: order order_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."order"
    ADD CONSTRAINT order_pkey PRIMARY KEY (id);


--
-- Name: order_promotion order_promotion_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_promotion
    ADD CONSTRAINT order_promotion_pkey PRIMARY KEY (order_id, promotion_id);


--
-- Name: order_shipping_method_adjustment order_shipping_method_adjustment_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_shipping_method_adjustment
    ADD CONSTRAINT order_shipping_method_adjustment_pkey PRIMARY KEY (id);


--
-- Name: order_shipping_method order_shipping_method_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_shipping_method
    ADD CONSTRAINT order_shipping_method_pkey PRIMARY KEY (id);


--
-- Name: order_shipping_method_tax_line order_shipping_method_tax_line_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_shipping_method_tax_line
    ADD CONSTRAINT order_shipping_method_tax_line_pkey PRIMARY KEY (id);


--
-- Name: order_shipping order_shipping_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_shipping
    ADD CONSTRAINT order_shipping_pkey PRIMARY KEY (id);


--
-- Name: order_summary order_summary_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_summary
    ADD CONSTRAINT order_summary_pkey PRIMARY KEY (id);


--
-- Name: order_transaction order_transaction_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_transaction
    ADD CONSTRAINT order_transaction_pkey PRIMARY KEY (id);


--
-- Name: payment_collection_payment_providers payment_collection_payment_providers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment_collection_payment_providers
    ADD CONSTRAINT payment_collection_payment_providers_pkey PRIMARY KEY (payment_collection_id, payment_provider_id);


--
-- Name: payment_collection payment_collection_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment_collection
    ADD CONSTRAINT payment_collection_pkey PRIMARY KEY (id);


--
-- Name: payment payment_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment
    ADD CONSTRAINT payment_pkey PRIMARY KEY (id);


--
-- Name: payment_provider payment_provider_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment_provider
    ADD CONSTRAINT payment_provider_pkey PRIMARY KEY (id);


--
-- Name: payment_session payment_session_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment_session
    ADD CONSTRAINT payment_session_pkey PRIMARY KEY (id);


--
-- Name: price_list price_list_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.price_list
    ADD CONSTRAINT price_list_pkey PRIMARY KEY (id);


--
-- Name: price_list_rule price_list_rule_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.price_list_rule
    ADD CONSTRAINT price_list_rule_pkey PRIMARY KEY (id);


--
-- Name: price price_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.price
    ADD CONSTRAINT price_pkey PRIMARY KEY (id);


--
-- Name: price_preference price_preference_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.price_preference
    ADD CONSTRAINT price_preference_pkey PRIMARY KEY (id);


--
-- Name: price_rule price_rule_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.price_rule
    ADD CONSTRAINT price_rule_pkey PRIMARY KEY (id);


--
-- Name: price_set price_set_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.price_set
    ADD CONSTRAINT price_set_pkey PRIMARY KEY (id);


--
-- Name: product_category product_category_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_category
    ADD CONSTRAINT product_category_pkey PRIMARY KEY (id);


--
-- Name: product_category_product product_category_product_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_category_product
    ADD CONSTRAINT product_category_product_pkey PRIMARY KEY (product_id, product_category_id);


--
-- Name: product_collection product_collection_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_collection
    ADD CONSTRAINT product_collection_pkey PRIMARY KEY (id);


--
-- Name: product_option product_option_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_option
    ADD CONSTRAINT product_option_pkey PRIMARY KEY (id);


--
-- Name: product_option_value product_option_value_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_option_value
    ADD CONSTRAINT product_option_value_pkey PRIMARY KEY (id);


--
-- Name: product product_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product
    ADD CONSTRAINT product_pkey PRIMARY KEY (id);


--
-- Name: product_sales_channel product_sales_channel_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_sales_channel
    ADD CONSTRAINT product_sales_channel_pkey PRIMARY KEY (product_id, sales_channel_id);


--
-- Name: product_shipping_profile product_shipping_profile_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_shipping_profile
    ADD CONSTRAINT product_shipping_profile_pkey PRIMARY KEY (product_id, shipping_profile_id);


--
-- Name: product_tag product_tag_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_tag
    ADD CONSTRAINT product_tag_pkey PRIMARY KEY (id);


--
-- Name: product_tags product_tags_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_tags
    ADD CONSTRAINT product_tags_pkey PRIMARY KEY (product_id, product_tag_id);


--
-- Name: product_type product_type_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_type
    ADD CONSTRAINT product_type_pkey PRIMARY KEY (id);


--
-- Name: product_variant_inventory_item product_variant_inventory_item_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_variant_inventory_item
    ADD CONSTRAINT product_variant_inventory_item_pkey PRIMARY KEY (variant_id, inventory_item_id);


--
-- Name: product_variant_option product_variant_option_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_variant_option
    ADD CONSTRAINT product_variant_option_pkey PRIMARY KEY (variant_id, option_value_id);


--
-- Name: product_variant product_variant_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_variant
    ADD CONSTRAINT product_variant_pkey PRIMARY KEY (id);


--
-- Name: product_variant_price_set product_variant_price_set_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_variant_price_set
    ADD CONSTRAINT product_variant_price_set_pkey PRIMARY KEY (variant_id, price_set_id);


--
-- Name: promotion_application_method promotion_application_method_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.promotion_application_method
    ADD CONSTRAINT promotion_application_method_pkey PRIMARY KEY (id);


--
-- Name: promotion_campaign_budget promotion_campaign_budget_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.promotion_campaign_budget
    ADD CONSTRAINT promotion_campaign_budget_pkey PRIMARY KEY (id);


--
-- Name: promotion_campaign promotion_campaign_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.promotion_campaign
    ADD CONSTRAINT promotion_campaign_pkey PRIMARY KEY (id);


--
-- Name: promotion promotion_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.promotion
    ADD CONSTRAINT promotion_pkey PRIMARY KEY (id);


--
-- Name: promotion_promotion_rule promotion_promotion_rule_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.promotion_promotion_rule
    ADD CONSTRAINT promotion_promotion_rule_pkey PRIMARY KEY (promotion_id, promotion_rule_id);


--
-- Name: promotion_rule promotion_rule_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.promotion_rule
    ADD CONSTRAINT promotion_rule_pkey PRIMARY KEY (id);


--
-- Name: promotion_rule_value promotion_rule_value_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.promotion_rule_value
    ADD CONSTRAINT promotion_rule_value_pkey PRIMARY KEY (id);


--
-- Name: provider_identity provider_identity_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.provider_identity
    ADD CONSTRAINT provider_identity_pkey PRIMARY KEY (id);


--
-- Name: publishable_api_key_sales_channel publishable_api_key_sales_channel_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.publishable_api_key_sales_channel
    ADD CONSTRAINT publishable_api_key_sales_channel_pkey PRIMARY KEY (publishable_key_id, sales_channel_id);


--
-- Name: refund refund_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.refund
    ADD CONSTRAINT refund_pkey PRIMARY KEY (id);


--
-- Name: refund_reason refund_reason_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.refund_reason
    ADD CONSTRAINT refund_reason_pkey PRIMARY KEY (id);


--
-- Name: region_country region_country_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.region_country
    ADD CONSTRAINT region_country_pkey PRIMARY KEY (iso_2);


--
-- Name: region_payment_provider region_payment_provider_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.region_payment_provider
    ADD CONSTRAINT region_payment_provider_pkey PRIMARY KEY (region_id, payment_provider_id);


--
-- Name: region region_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.region
    ADD CONSTRAINT region_pkey PRIMARY KEY (id);


--
-- Name: reservation_item reservation_item_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reservation_item
    ADD CONSTRAINT reservation_item_pkey PRIMARY KEY (id);


--
-- Name: return_fulfillment return_fulfillment_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.return_fulfillment
    ADD CONSTRAINT return_fulfillment_pkey PRIMARY KEY (return_id, fulfillment_id);


--
-- Name: return_item return_item_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.return_item
    ADD CONSTRAINT return_item_pkey PRIMARY KEY (id);


--
-- Name: return return_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.return
    ADD CONSTRAINT return_pkey PRIMARY KEY (id);


--
-- Name: return_reason return_reason_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.return_reason
    ADD CONSTRAINT return_reason_pkey PRIMARY KEY (id);


--
-- Name: sales_channel sales_channel_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sales_channel
    ADD CONSTRAINT sales_channel_pkey PRIMARY KEY (id);


--
-- Name: sales_channel_stock_location sales_channel_stock_location_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sales_channel_stock_location
    ADD CONSTRAINT sales_channel_stock_location_pkey PRIMARY KEY (sales_channel_id, stock_location_id);


--
-- Name: script_migrations script_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.script_migrations
    ADD CONSTRAINT script_migrations_pkey PRIMARY KEY (id);


--
-- Name: service_zone service_zone_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.service_zone
    ADD CONSTRAINT service_zone_pkey PRIMARY KEY (id);


--
-- Name: shipping_option shipping_option_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shipping_option
    ADD CONSTRAINT shipping_option_pkey PRIMARY KEY (id);


--
-- Name: shipping_option_price_set shipping_option_price_set_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shipping_option_price_set
    ADD CONSTRAINT shipping_option_price_set_pkey PRIMARY KEY (shipping_option_id, price_set_id);


--
-- Name: shipping_option_rule shipping_option_rule_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shipping_option_rule
    ADD CONSTRAINT shipping_option_rule_pkey PRIMARY KEY (id);


--
-- Name: shipping_option_type shipping_option_type_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shipping_option_type
    ADD CONSTRAINT shipping_option_type_pkey PRIMARY KEY (id);


--
-- Name: shipping_profile shipping_profile_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shipping_profile
    ADD CONSTRAINT shipping_profile_pkey PRIMARY KEY (id);


--
-- Name: stock_location_address stock_location_address_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stock_location_address
    ADD CONSTRAINT stock_location_address_pkey PRIMARY KEY (id);


--
-- Name: stock_location stock_location_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stock_location
    ADD CONSTRAINT stock_location_pkey PRIMARY KEY (id);


--
-- Name: store_currency store_currency_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.store_currency
    ADD CONSTRAINT store_currency_pkey PRIMARY KEY (id);


--
-- Name: store store_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.store
    ADD CONSTRAINT store_pkey PRIMARY KEY (id);


--
-- Name: tax_provider tax_provider_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tax_provider
    ADD CONSTRAINT tax_provider_pkey PRIMARY KEY (id);


--
-- Name: tax_rate tax_rate_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tax_rate
    ADD CONSTRAINT tax_rate_pkey PRIMARY KEY (id);


--
-- Name: tax_rate_rule tax_rate_rule_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tax_rate_rule
    ADD CONSTRAINT tax_rate_rule_pkey PRIMARY KEY (id);


--
-- Name: tax_region tax_region_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tax_region
    ADD CONSTRAINT tax_region_pkey PRIMARY KEY (id);


--
-- Name: user user_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT user_pkey PRIMARY KEY (id);


--
-- Name: user_preference user_preference_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_preference
    ADD CONSTRAINT user_preference_pkey PRIMARY KEY (id);


--
-- Name: view_configuration view_configuration_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.view_configuration
    ADD CONSTRAINT view_configuration_pkey PRIMARY KEY (id);


--
-- Name: workflow_execution workflow_execution_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workflow_execution
    ADD CONSTRAINT workflow_execution_pkey PRIMARY KEY (workflow_id, transaction_id, run_id);


--
-- Name: IDX_account_holder_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_account_holder_deleted_at" ON public.account_holder USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_account_holder_id_5cb3a0c0; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_account_holder_id_5cb3a0c0" ON public.customer_account_holder USING btree (account_holder_id);


--
-- Name: IDX_account_holder_provider_id_external_id_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_account_holder_provider_id_external_id_unique" ON public.account_holder USING btree (provider_id, external_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_adjustment_item_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_adjustment_item_id" ON public.cart_line_item_adjustment USING btree (item_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_adjustment_shipping_method_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_adjustment_shipping_method_id" ON public.cart_shipping_method_adjustment USING btree (shipping_method_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_api_key_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_api_key_deleted_at" ON public.api_key USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_api_key_token_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_api_key_token_unique" ON public.api_key USING btree (token);


--
-- Name: IDX_api_key_type; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_api_key_type" ON public.api_key USING btree (type);


--
-- Name: IDX_application_method_allocation; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_application_method_allocation" ON public.promotion_application_method USING btree (allocation);


--
-- Name: IDX_application_method_target_type; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_application_method_target_type" ON public.promotion_application_method USING btree (target_type);


--
-- Name: IDX_application_method_type; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_application_method_type" ON public.promotion_application_method USING btree (type);


--
-- Name: IDX_auth_identity_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_auth_identity_deleted_at" ON public.auth_identity USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_campaign_budget_type; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_campaign_budget_type" ON public.promotion_campaign_budget USING btree (type);


--
-- Name: IDX_capture_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_capture_deleted_at" ON public.capture USING btree (deleted_at);


--
-- Name: IDX_capture_payment_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_capture_payment_id" ON public.capture USING btree (payment_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_cart_address_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_cart_address_deleted_at" ON public.cart_address USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_cart_billing_address_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_cart_billing_address_id" ON public.cart USING btree (billing_address_id) WHERE ((deleted_at IS NULL) AND (billing_address_id IS NOT NULL));


--
-- Name: IDX_cart_credit_line_reference_reference_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_cart_credit_line_reference_reference_id" ON public.credit_line USING btree (reference, reference_id) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_cart_currency_code; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_cart_currency_code" ON public.cart USING btree (currency_code);


--
-- Name: IDX_cart_customer_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_cart_customer_id" ON public.cart USING btree (customer_id) WHERE ((deleted_at IS NULL) AND (customer_id IS NOT NULL));


--
-- Name: IDX_cart_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_cart_deleted_at" ON public.cart USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_cart_id_-4a39f6c9; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_cart_id_-4a39f6c9" ON public.cart_payment_collection USING btree (cart_id);


--
-- Name: IDX_cart_id_-71069c16; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_cart_id_-71069c16" ON public.order_cart USING btree (cart_id);


--
-- Name: IDX_cart_id_-a9d4a70b; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_cart_id_-a9d4a70b" ON public.cart_promotion USING btree (cart_id);


--
-- Name: IDX_cart_line_item_adjustment_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_cart_line_item_adjustment_deleted_at" ON public.cart_line_item_adjustment USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_cart_line_item_adjustment_item_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_cart_line_item_adjustment_item_id" ON public.cart_line_item_adjustment USING btree (item_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_cart_line_item_cart_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_cart_line_item_cart_id" ON public.cart_line_item USING btree (cart_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_cart_line_item_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_cart_line_item_deleted_at" ON public.cart_line_item USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_cart_line_item_tax_line_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_cart_line_item_tax_line_deleted_at" ON public.cart_line_item_tax_line USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_cart_line_item_tax_line_item_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_cart_line_item_tax_line_item_id" ON public.cart_line_item_tax_line USING btree (item_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_cart_region_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_cart_region_id" ON public.cart USING btree (region_id) WHERE ((deleted_at IS NULL) AND (region_id IS NOT NULL));


--
-- Name: IDX_cart_sales_channel_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_cart_sales_channel_id" ON public.cart USING btree (sales_channel_id) WHERE ((deleted_at IS NULL) AND (sales_channel_id IS NOT NULL));


--
-- Name: IDX_cart_shipping_address_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_cart_shipping_address_id" ON public.cart USING btree (shipping_address_id) WHERE ((deleted_at IS NULL) AND (shipping_address_id IS NOT NULL));


--
-- Name: IDX_cart_shipping_method_adjustment_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_cart_shipping_method_adjustment_deleted_at" ON public.cart_shipping_method_adjustment USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_cart_shipping_method_adjustment_shipping_method_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_cart_shipping_method_adjustment_shipping_method_id" ON public.cart_shipping_method_adjustment USING btree (shipping_method_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_cart_shipping_method_cart_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_cart_shipping_method_cart_id" ON public.cart_shipping_method USING btree (cart_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_cart_shipping_method_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_cart_shipping_method_deleted_at" ON public.cart_shipping_method USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_cart_shipping_method_tax_line_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_cart_shipping_method_tax_line_deleted_at" ON public.cart_shipping_method_tax_line USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_cart_shipping_method_tax_line_shipping_method_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_cart_shipping_method_tax_line_shipping_method_id" ON public.cart_shipping_method_tax_line USING btree (shipping_method_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_category_handle_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_category_handle_unique" ON public.product_category USING btree (handle) WHERE (deleted_at IS NULL);


--
-- Name: IDX_collection_handle_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_collection_handle_unique" ON public.product_collection USING btree (handle) WHERE (deleted_at IS NULL);


--
-- Name: IDX_credit_line_cart_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_credit_line_cart_id" ON public.credit_line USING btree (cart_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_credit_line_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_credit_line_deleted_at" ON public.credit_line USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_customer_address_customer_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_customer_address_customer_id" ON public.customer_address USING btree (customer_id);


--
-- Name: IDX_customer_address_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_customer_address_deleted_at" ON public.customer_address USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_customer_address_unique_customer_billing; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_customer_address_unique_customer_billing" ON public.customer_address USING btree (customer_id) WHERE (is_default_billing = true);


--
-- Name: IDX_customer_address_unique_customer_shipping; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_customer_address_unique_customer_shipping" ON public.customer_address USING btree (customer_id) WHERE (is_default_shipping = true);


--
-- Name: IDX_customer_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_customer_deleted_at" ON public.customer USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_customer_email_has_account_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_customer_email_has_account_unique" ON public.customer USING btree (email, has_account) WHERE (deleted_at IS NULL);


--
-- Name: IDX_customer_group_customer_customer_group_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_customer_group_customer_customer_group_id" ON public.customer_group_customer USING btree (customer_group_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_customer_group_customer_customer_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_customer_group_customer_customer_id" ON public.customer_group_customer USING btree (customer_id);


--
-- Name: IDX_customer_group_customer_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_customer_group_customer_deleted_at" ON public.customer_group_customer USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_customer_group_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_customer_group_deleted_at" ON public.customer_group USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_customer_group_name; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_customer_group_name" ON public.customer_group USING btree (name) WHERE (deleted_at IS NULL);


--
-- Name: IDX_customer_group_name_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_customer_group_name_unique" ON public.customer_group USING btree (name) WHERE (deleted_at IS NULL);


--
-- Name: IDX_customer_id_5cb3a0c0; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_customer_id_5cb3a0c0" ON public.customer_account_holder USING btree (customer_id);


--
-- Name: IDX_deleted_at_-1d67bae40; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_deleted_at_-1d67bae40" ON public.publishable_api_key_sales_channel USING btree (deleted_at);


--
-- Name: IDX_deleted_at_-1e5992737; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_deleted_at_-1e5992737" ON public.location_fulfillment_provider USING btree (deleted_at);


--
-- Name: IDX_deleted_at_-31ea43a; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_deleted_at_-31ea43a" ON public.return_fulfillment USING btree (deleted_at);


--
-- Name: IDX_deleted_at_-4a39f6c9; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_deleted_at_-4a39f6c9" ON public.cart_payment_collection USING btree (deleted_at);


--
-- Name: IDX_deleted_at_-71069c16; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_deleted_at_-71069c16" ON public.order_cart USING btree (deleted_at);


--
-- Name: IDX_deleted_at_-71518339; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_deleted_at_-71518339" ON public.order_promotion USING btree (deleted_at);


--
-- Name: IDX_deleted_at_-a9d4a70b; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_deleted_at_-a9d4a70b" ON public.cart_promotion USING btree (deleted_at);


--
-- Name: IDX_deleted_at_-e88adb96; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_deleted_at_-e88adb96" ON public.location_fulfillment_set USING btree (deleted_at);


--
-- Name: IDX_deleted_at_-e8d2543e; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_deleted_at_-e8d2543e" ON public.order_fulfillment USING btree (deleted_at);


--
-- Name: IDX_deleted_at_17a262437; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_deleted_at_17a262437" ON public.product_shipping_profile USING btree (deleted_at);


--
-- Name: IDX_deleted_at_17b4c4e35; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_deleted_at_17b4c4e35" ON public.product_variant_inventory_item USING btree (deleted_at);


--
-- Name: IDX_deleted_at_1c934dab0; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_deleted_at_1c934dab0" ON public.region_payment_provider USING btree (deleted_at);


--
-- Name: IDX_deleted_at_20b454295; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_deleted_at_20b454295" ON public.product_sales_channel USING btree (deleted_at);


--
-- Name: IDX_deleted_at_26d06f470; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_deleted_at_26d06f470" ON public.sales_channel_stock_location USING btree (deleted_at);


--
-- Name: IDX_deleted_at_52b23597; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_deleted_at_52b23597" ON public.product_variant_price_set USING btree (deleted_at);


--
-- Name: IDX_deleted_at_5cb3a0c0; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_deleted_at_5cb3a0c0" ON public.customer_account_holder USING btree (deleted_at);


--
-- Name: IDX_deleted_at_ba32fa9c; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_deleted_at_ba32fa9c" ON public.shipping_option_price_set USING btree (deleted_at);


--
-- Name: IDX_deleted_at_f42b9949; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_deleted_at_f42b9949" ON public.order_payment_collection USING btree (deleted_at);


--
-- Name: IDX_fulfillment_address_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_fulfillment_address_deleted_at" ON public.fulfillment_address USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_fulfillment_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_fulfillment_deleted_at" ON public.fulfillment USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_fulfillment_id_-31ea43a; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_fulfillment_id_-31ea43a" ON public.return_fulfillment USING btree (fulfillment_id);


--
-- Name: IDX_fulfillment_id_-e8d2543e; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_fulfillment_id_-e8d2543e" ON public.order_fulfillment USING btree (fulfillment_id);


--
-- Name: IDX_fulfillment_item_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_fulfillment_item_deleted_at" ON public.fulfillment_item USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_fulfillment_item_fulfillment_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_fulfillment_item_fulfillment_id" ON public.fulfillment_item USING btree (fulfillment_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_fulfillment_item_inventory_item_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_fulfillment_item_inventory_item_id" ON public.fulfillment_item USING btree (inventory_item_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_fulfillment_item_line_item_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_fulfillment_item_line_item_id" ON public.fulfillment_item USING btree (line_item_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_fulfillment_label_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_fulfillment_label_deleted_at" ON public.fulfillment_label USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_fulfillment_label_fulfillment_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_fulfillment_label_fulfillment_id" ON public.fulfillment_label USING btree (fulfillment_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_fulfillment_location_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_fulfillment_location_id" ON public.fulfillment USING btree (location_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_fulfillment_provider_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_fulfillment_provider_deleted_at" ON public.fulfillment_provider USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_fulfillment_provider_id_-1e5992737; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_fulfillment_provider_id_-1e5992737" ON public.location_fulfillment_provider USING btree (fulfillment_provider_id);


--
-- Name: IDX_fulfillment_set_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_fulfillment_set_deleted_at" ON public.fulfillment_set USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_fulfillment_set_id_-e88adb96; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_fulfillment_set_id_-e88adb96" ON public.location_fulfillment_set USING btree (fulfillment_set_id);


--
-- Name: IDX_fulfillment_set_name_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_fulfillment_set_name_unique" ON public.fulfillment_set USING btree (name) WHERE (deleted_at IS NULL);


--
-- Name: IDX_fulfillment_shipping_option_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_fulfillment_shipping_option_id" ON public.fulfillment USING btree (shipping_option_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_geo_zone_city; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_geo_zone_city" ON public.geo_zone USING btree (city) WHERE ((deleted_at IS NULL) AND (city IS NOT NULL));


--
-- Name: IDX_geo_zone_country_code; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_geo_zone_country_code" ON public.geo_zone USING btree (country_code) WHERE (deleted_at IS NULL);


--
-- Name: IDX_geo_zone_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_geo_zone_deleted_at" ON public.geo_zone USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_geo_zone_province_code; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_geo_zone_province_code" ON public.geo_zone USING btree (province_code) WHERE ((deleted_at IS NULL) AND (province_code IS NOT NULL));


--
-- Name: IDX_geo_zone_service_zone_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_geo_zone_service_zone_id" ON public.geo_zone USING btree (service_zone_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_id_-1d67bae40; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_id_-1d67bae40" ON public.publishable_api_key_sales_channel USING btree (id);


--
-- Name: IDX_id_-1e5992737; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_id_-1e5992737" ON public.location_fulfillment_provider USING btree (id);


--
-- Name: IDX_id_-31ea43a; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_id_-31ea43a" ON public.return_fulfillment USING btree (id);


--
-- Name: IDX_id_-4a39f6c9; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_id_-4a39f6c9" ON public.cart_payment_collection USING btree (id);


--
-- Name: IDX_id_-71069c16; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_id_-71069c16" ON public.order_cart USING btree (id);


--
-- Name: IDX_id_-71518339; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_id_-71518339" ON public.order_promotion USING btree (id);


--
-- Name: IDX_id_-a9d4a70b; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_id_-a9d4a70b" ON public.cart_promotion USING btree (id);


--
-- Name: IDX_id_-e88adb96; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_id_-e88adb96" ON public.location_fulfillment_set USING btree (id);


--
-- Name: IDX_id_-e8d2543e; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_id_-e8d2543e" ON public.order_fulfillment USING btree (id);


--
-- Name: IDX_id_17a262437; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_id_17a262437" ON public.product_shipping_profile USING btree (id);


--
-- Name: IDX_id_17b4c4e35; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_id_17b4c4e35" ON public.product_variant_inventory_item USING btree (id);


--
-- Name: IDX_id_1c934dab0; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_id_1c934dab0" ON public.region_payment_provider USING btree (id);


--
-- Name: IDX_id_20b454295; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_id_20b454295" ON public.product_sales_channel USING btree (id);


--
-- Name: IDX_id_26d06f470; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_id_26d06f470" ON public.sales_channel_stock_location USING btree (id);


--
-- Name: IDX_id_52b23597; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_id_52b23597" ON public.product_variant_price_set USING btree (id);


--
-- Name: IDX_id_5cb3a0c0; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_id_5cb3a0c0" ON public.customer_account_holder USING btree (id);


--
-- Name: IDX_id_ba32fa9c; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_id_ba32fa9c" ON public.shipping_option_price_set USING btree (id);


--
-- Name: IDX_id_f42b9949; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_id_f42b9949" ON public.order_payment_collection USING btree (id);


--
-- Name: IDX_image_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_image_deleted_at" ON public.image USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_image_product_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_image_product_id" ON public.image USING btree (product_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_inventory_item_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_inventory_item_deleted_at" ON public.inventory_item USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_inventory_item_id_17b4c4e35; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_inventory_item_id_17b4c4e35" ON public.product_variant_inventory_item USING btree (inventory_item_id);


--
-- Name: IDX_inventory_item_sku; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_inventory_item_sku" ON public.inventory_item USING btree (sku) WHERE (deleted_at IS NULL);


--
-- Name: IDX_inventory_level_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_inventory_level_deleted_at" ON public.inventory_level USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_inventory_level_inventory_item_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_inventory_level_inventory_item_id" ON public.inventory_level USING btree (inventory_item_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_inventory_level_item_location; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_inventory_level_item_location" ON public.inventory_level USING btree (inventory_item_id, location_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_inventory_level_location_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_inventory_level_location_id" ON public.inventory_level USING btree (location_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_inventory_level_location_id_inventory_item_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_inventory_level_location_id_inventory_item_id" ON public.inventory_level USING btree (inventory_item_id, location_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_invite_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_invite_deleted_at" ON public.invite USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_invite_email_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_invite_email_unique" ON public.invite USING btree (email) WHERE (deleted_at IS NULL);


--
-- Name: IDX_invite_token; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_invite_token" ON public.invite USING btree (token) WHERE (deleted_at IS NULL);


--
-- Name: IDX_line_item_adjustment_promotion_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_line_item_adjustment_promotion_id" ON public.cart_line_item_adjustment USING btree (promotion_id) WHERE ((deleted_at IS NULL) AND (promotion_id IS NOT NULL));


--
-- Name: IDX_line_item_cart_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_line_item_cart_id" ON public.cart_line_item USING btree (cart_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_line_item_product_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_line_item_product_id" ON public.cart_line_item USING btree (product_id) WHERE ((deleted_at IS NULL) AND (product_id IS NOT NULL));


--
-- Name: IDX_line_item_product_type_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_line_item_product_type_id" ON public.cart_line_item USING btree (product_type_id) WHERE ((deleted_at IS NULL) AND (product_type_id IS NOT NULL));


--
-- Name: IDX_line_item_tax_line_tax_rate_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_line_item_tax_line_tax_rate_id" ON public.cart_line_item_tax_line USING btree (tax_rate_id) WHERE ((deleted_at IS NULL) AND (tax_rate_id IS NOT NULL));


--
-- Name: IDX_line_item_variant_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_line_item_variant_id" ON public.cart_line_item USING btree (variant_id) WHERE ((deleted_at IS NULL) AND (variant_id IS NOT NULL));


--
-- Name: IDX_notification_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_notification_deleted_at" ON public.notification USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_notification_idempotency_key_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_notification_idempotency_key_unique" ON public.notification USING btree (idempotency_key) WHERE (deleted_at IS NULL);


--
-- Name: IDX_notification_provider_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_notification_provider_deleted_at" ON public.notification_provider USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_notification_provider_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_notification_provider_id" ON public.notification USING btree (provider_id);


--
-- Name: IDX_notification_receiver_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_notification_receiver_id" ON public.notification USING btree (receiver_id);


--
-- Name: IDX_option_product_id_title_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_option_product_id_title_unique" ON public.product_option USING btree (product_id, title) WHERE (deleted_at IS NULL);


--
-- Name: IDX_option_value_option_id_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_option_value_option_id_unique" ON public.product_option_value USING btree (option_id, value) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_address_customer_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_address_customer_id" ON public.order_address USING btree (customer_id);


--
-- Name: IDX_order_address_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_address_deleted_at" ON public.order_address USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_billing_address_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_billing_address_id" ON public."order" USING btree (billing_address_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_change_action_claim_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_change_action_claim_id" ON public.order_change_action USING btree (claim_id) WHERE ((claim_id IS NOT NULL) AND (deleted_at IS NULL));


--
-- Name: IDX_order_change_action_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_change_action_deleted_at" ON public.order_change_action USING btree (deleted_at);


--
-- Name: IDX_order_change_action_exchange_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_change_action_exchange_id" ON public.order_change_action USING btree (exchange_id) WHERE ((exchange_id IS NOT NULL) AND (deleted_at IS NULL));


--
-- Name: IDX_order_change_action_order_change_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_change_action_order_change_id" ON public.order_change_action USING btree (order_change_id);


--
-- Name: IDX_order_change_action_order_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_change_action_order_id" ON public.order_change_action USING btree (order_id);


--
-- Name: IDX_order_change_action_ordering; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_change_action_ordering" ON public.order_change_action USING btree (ordering);


--
-- Name: IDX_order_change_action_return_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_change_action_return_id" ON public.order_change_action USING btree (return_id) WHERE ((return_id IS NOT NULL) AND (deleted_at IS NULL));


--
-- Name: IDX_order_change_change_type; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_change_change_type" ON public.order_change USING btree (change_type);


--
-- Name: IDX_order_change_claim_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_change_claim_id" ON public.order_change USING btree (claim_id) WHERE ((claim_id IS NOT NULL) AND (deleted_at IS NULL));


--
-- Name: IDX_order_change_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_change_deleted_at" ON public.order_change USING btree (deleted_at);


--
-- Name: IDX_order_change_exchange_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_change_exchange_id" ON public.order_change USING btree (exchange_id) WHERE ((exchange_id IS NOT NULL) AND (deleted_at IS NULL));


--
-- Name: IDX_order_change_order_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_change_order_id" ON public.order_change USING btree (order_id);


--
-- Name: IDX_order_change_order_id_version; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_change_order_id_version" ON public.order_change USING btree (order_id, version);


--
-- Name: IDX_order_change_return_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_change_return_id" ON public.order_change USING btree (return_id) WHERE ((return_id IS NOT NULL) AND (deleted_at IS NULL));


--
-- Name: IDX_order_change_status; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_change_status" ON public.order_change USING btree (status);


--
-- Name: IDX_order_claim_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_claim_deleted_at" ON public.order_claim USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_claim_display_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_claim_display_id" ON public.order_claim USING btree (display_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_claim_item_claim_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_claim_item_claim_id" ON public.order_claim_item USING btree (claim_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_claim_item_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_claim_item_deleted_at" ON public.order_claim_item USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_claim_item_image_claim_item_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_claim_item_image_claim_item_id" ON public.order_claim_item_image USING btree (claim_item_id) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_order_claim_item_image_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_claim_item_image_deleted_at" ON public.order_claim_item_image USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_order_claim_item_item_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_claim_item_item_id" ON public.order_claim_item USING btree (item_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_claim_order_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_claim_order_id" ON public.order_claim USING btree (order_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_claim_return_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_claim_return_id" ON public.order_claim USING btree (return_id) WHERE ((return_id IS NOT NULL) AND (deleted_at IS NULL));


--
-- Name: IDX_order_credit_line_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_credit_line_deleted_at" ON public.order_credit_line USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_order_credit_line_order_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_credit_line_order_id" ON public.order_credit_line USING btree (order_id) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_order_currency_code; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_currency_code" ON public."order" USING btree (currency_code) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_customer_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_customer_id" ON public."order" USING btree (customer_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_deleted_at" ON public."order" USING btree (deleted_at);


--
-- Name: IDX_order_display_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_display_id" ON public."order" USING btree (display_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_exchange_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_exchange_deleted_at" ON public.order_exchange USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_exchange_display_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_exchange_display_id" ON public.order_exchange USING btree (display_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_exchange_item_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_exchange_item_deleted_at" ON public.order_exchange_item USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_exchange_item_exchange_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_exchange_item_exchange_id" ON public.order_exchange_item USING btree (exchange_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_exchange_item_item_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_exchange_item_item_id" ON public.order_exchange_item USING btree (item_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_exchange_order_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_exchange_order_id" ON public.order_exchange USING btree (order_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_exchange_return_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_exchange_return_id" ON public.order_exchange USING btree (return_id) WHERE ((return_id IS NOT NULL) AND (deleted_at IS NULL));


--
-- Name: IDX_order_id_-71069c16; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_id_-71069c16" ON public.order_cart USING btree (order_id);


--
-- Name: IDX_order_id_-71518339; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_id_-71518339" ON public.order_promotion USING btree (order_id);


--
-- Name: IDX_order_id_-e8d2543e; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_id_-e8d2543e" ON public.order_fulfillment USING btree (order_id);


--
-- Name: IDX_order_id_f42b9949; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_id_f42b9949" ON public.order_payment_collection USING btree (order_id);


--
-- Name: IDX_order_is_draft_order; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_is_draft_order" ON public."order" USING btree (is_draft_order) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_item_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_item_deleted_at" ON public.order_item USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_order_item_item_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_item_item_id" ON public.order_item USING btree (item_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_item_order_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_item_order_id" ON public.order_item USING btree (order_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_item_order_id_version; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_item_order_id_version" ON public.order_item USING btree (order_id, version) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_line_item_adjustment_item_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_line_item_adjustment_item_id" ON public.order_line_item_adjustment USING btree (item_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_line_item_product_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_line_item_product_id" ON public.order_line_item USING btree (product_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_line_item_tax_line_item_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_line_item_tax_line_item_id" ON public.order_line_item_tax_line USING btree (item_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_line_item_variant_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_line_item_variant_id" ON public.order_line_item USING btree (variant_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_region_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_region_id" ON public."order" USING btree (region_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_shipping_address_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_shipping_address_id" ON public."order" USING btree (shipping_address_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_shipping_claim_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_shipping_claim_id" ON public.order_shipping USING btree (claim_id) WHERE ((claim_id IS NOT NULL) AND (deleted_at IS NULL));


--
-- Name: IDX_order_shipping_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_shipping_deleted_at" ON public.order_shipping USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_order_shipping_exchange_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_shipping_exchange_id" ON public.order_shipping USING btree (exchange_id) WHERE ((exchange_id IS NOT NULL) AND (deleted_at IS NULL));


--
-- Name: IDX_order_shipping_item_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_shipping_item_id" ON public.order_shipping USING btree (shipping_method_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_shipping_method_adjustment_shipping_method_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_shipping_method_adjustment_shipping_method_id" ON public.order_shipping_method_adjustment USING btree (shipping_method_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_shipping_method_shipping_option_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_shipping_method_shipping_option_id" ON public.order_shipping_method USING btree (shipping_option_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_shipping_method_tax_line_shipping_method_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_shipping_method_tax_line_shipping_method_id" ON public.order_shipping_method_tax_line USING btree (shipping_method_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_shipping_order_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_shipping_order_id" ON public.order_shipping USING btree (order_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_shipping_order_id_version; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_shipping_order_id_version" ON public.order_shipping USING btree (order_id, version) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_shipping_return_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_shipping_return_id" ON public.order_shipping USING btree (return_id) WHERE ((return_id IS NOT NULL) AND (deleted_at IS NULL));


--
-- Name: IDX_order_summary_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_summary_deleted_at" ON public.order_summary USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_order_summary_order_id_version; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_summary_order_id_version" ON public.order_summary USING btree (order_id, version) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_transaction_claim_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_transaction_claim_id" ON public.order_transaction USING btree (claim_id) WHERE ((claim_id IS NOT NULL) AND (deleted_at IS NULL));


--
-- Name: IDX_order_transaction_currency_code; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_transaction_currency_code" ON public.order_transaction USING btree (currency_code) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_transaction_exchange_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_transaction_exchange_id" ON public.order_transaction USING btree (exchange_id) WHERE ((exchange_id IS NOT NULL) AND (deleted_at IS NULL));


--
-- Name: IDX_order_transaction_order_id_version; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_transaction_order_id_version" ON public.order_transaction USING btree (order_id, version) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_transaction_reference_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_transaction_reference_id" ON public.order_transaction USING btree (reference_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_transaction_return_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_transaction_return_id" ON public.order_transaction USING btree (return_id) WHERE ((return_id IS NOT NULL) AND (deleted_at IS NULL));


--
-- Name: IDX_payment_collection_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_payment_collection_deleted_at" ON public.payment_collection USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_payment_collection_id_-4a39f6c9; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_payment_collection_id_-4a39f6c9" ON public.cart_payment_collection USING btree (payment_collection_id);


--
-- Name: IDX_payment_collection_id_f42b9949; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_payment_collection_id_f42b9949" ON public.order_payment_collection USING btree (payment_collection_id);


--
-- Name: IDX_payment_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_payment_deleted_at" ON public.payment USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_payment_payment_collection_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_payment_payment_collection_id" ON public.payment USING btree (payment_collection_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_payment_payment_session_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_payment_payment_session_id" ON public.payment USING btree (payment_session_id);


--
-- Name: IDX_payment_payment_session_id_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_payment_payment_session_id_unique" ON public.payment USING btree (payment_session_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_payment_provider_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_payment_provider_deleted_at" ON public.payment_provider USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_payment_provider_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_payment_provider_id" ON public.payment USING btree (provider_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_payment_provider_id_1c934dab0; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_payment_provider_id_1c934dab0" ON public.region_payment_provider USING btree (payment_provider_id);


--
-- Name: IDX_payment_session_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_payment_session_deleted_at" ON public.payment_session USING btree (deleted_at);


--
-- Name: IDX_payment_session_payment_collection_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_payment_session_payment_collection_id" ON public.payment_session USING btree (payment_collection_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_price_currency_code; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_price_currency_code" ON public.price USING btree (currency_code) WHERE (deleted_at IS NULL);


--
-- Name: IDX_price_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_price_deleted_at" ON public.price USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_price_list_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_price_list_deleted_at" ON public.price_list USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_price_list_rule_attribute; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_price_list_rule_attribute" ON public.price_list_rule USING btree (attribute) WHERE (deleted_at IS NULL);


--
-- Name: IDX_price_list_rule_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_price_list_rule_deleted_at" ON public.price_list_rule USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_price_list_rule_price_list_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_price_list_rule_price_list_id" ON public.price_list_rule USING btree (price_list_id) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_price_preference_attribute_value; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_price_preference_attribute_value" ON public.price_preference USING btree (attribute, value) WHERE (deleted_at IS NULL);


--
-- Name: IDX_price_preference_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_price_preference_deleted_at" ON public.price_preference USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_price_price_list_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_price_price_list_id" ON public.price USING btree (price_list_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_price_price_set_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_price_price_set_id" ON public.price USING btree (price_set_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_price_rule_attribute; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_price_rule_attribute" ON public.price_rule USING btree (attribute) WHERE (deleted_at IS NULL);


--
-- Name: IDX_price_rule_attribute_value; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_price_rule_attribute_value" ON public.price_rule USING btree (attribute, value) WHERE (deleted_at IS NULL);


--
-- Name: IDX_price_rule_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_price_rule_deleted_at" ON public.price_rule USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_price_rule_operator; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_price_rule_operator" ON public.price_rule USING btree (operator);


--
-- Name: IDX_price_rule_operator_value; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_price_rule_operator_value" ON public.price_rule USING btree (operator, value) WHERE (deleted_at IS NULL);


--
-- Name: IDX_price_rule_price_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_price_rule_price_id" ON public.price_rule USING btree (price_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_price_rule_price_id_attribute_operator_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_price_rule_price_id_attribute_operator_unique" ON public.price_rule USING btree (price_id, attribute, operator) WHERE (deleted_at IS NULL);


--
-- Name: IDX_price_set_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_price_set_deleted_at" ON public.price_set USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_price_set_id_52b23597; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_price_set_id_52b23597" ON public.product_variant_price_set USING btree (price_set_id);


--
-- Name: IDX_price_set_id_ba32fa9c; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_price_set_id_ba32fa9c" ON public.shipping_option_price_set USING btree (price_set_id);


--
-- Name: IDX_product_category_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_product_category_deleted_at" ON public.product_collection USING btree (deleted_at);


--
-- Name: IDX_product_category_parent_category_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_product_category_parent_category_id" ON public.product_category USING btree (parent_category_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_product_category_path; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_product_category_path" ON public.product_category USING btree (mpath) WHERE (deleted_at IS NULL);


--
-- Name: IDX_product_collection_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_product_collection_deleted_at" ON public.product_collection USING btree (deleted_at);


--
-- Name: IDX_product_collection_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_product_collection_id" ON public.product USING btree (collection_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_product_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_product_deleted_at" ON public.product USING btree (deleted_at);


--
-- Name: IDX_product_handle_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_product_handle_unique" ON public.product USING btree (handle) WHERE (deleted_at IS NULL);


--
-- Name: IDX_product_id_17a262437; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_product_id_17a262437" ON public.product_shipping_profile USING btree (product_id);


--
-- Name: IDX_product_id_20b454295; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_product_id_20b454295" ON public.product_sales_channel USING btree (product_id);


--
-- Name: IDX_product_image_url; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_product_image_url" ON public.image USING btree (url) WHERE (deleted_at IS NULL);


--
-- Name: IDX_product_option_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_product_option_deleted_at" ON public.product_option USING btree (deleted_at);


--
-- Name: IDX_product_option_product_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_product_option_product_id" ON public.product_option USING btree (product_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_product_option_value_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_product_option_value_deleted_at" ON public.product_option_value USING btree (deleted_at);


--
-- Name: IDX_product_option_value_option_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_product_option_value_option_id" ON public.product_option_value USING btree (option_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_product_tag_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_product_tag_deleted_at" ON public.product_tag USING btree (deleted_at);


--
-- Name: IDX_product_type_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_product_type_deleted_at" ON public.product_type USING btree (deleted_at);


--
-- Name: IDX_product_type_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_product_type_id" ON public.product USING btree (type_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_product_variant_barcode_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_product_variant_barcode_unique" ON public.product_variant USING btree (barcode) WHERE (deleted_at IS NULL);


--
-- Name: IDX_product_variant_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_product_variant_deleted_at" ON public.product_variant USING btree (deleted_at);


--
-- Name: IDX_product_variant_ean_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_product_variant_ean_unique" ON public.product_variant USING btree (ean) WHERE (deleted_at IS NULL);


--
-- Name: IDX_product_variant_id_product_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_product_variant_id_product_id" ON public.product_variant USING btree (id, product_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_product_variant_product_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_product_variant_product_id" ON public.product_variant USING btree (product_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_product_variant_sku_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_product_variant_sku_unique" ON public.product_variant USING btree (sku) WHERE (deleted_at IS NULL);


--
-- Name: IDX_product_variant_upc_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_product_variant_upc_unique" ON public.product_variant USING btree (upc) WHERE (deleted_at IS NULL);


--
-- Name: IDX_promotion_application_method_currency_code; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_promotion_application_method_currency_code" ON public.promotion_application_method USING btree (currency_code) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_promotion_application_method_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_promotion_application_method_deleted_at" ON public.promotion_application_method USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_promotion_application_method_promotion_id_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_promotion_application_method_promotion_id_unique" ON public.promotion_application_method USING btree (promotion_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_promotion_campaign_budget_campaign_id_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_promotion_campaign_budget_campaign_id_unique" ON public.promotion_campaign_budget USING btree (campaign_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_promotion_campaign_budget_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_promotion_campaign_budget_deleted_at" ON public.promotion_campaign_budget USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_promotion_campaign_campaign_identifier_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_promotion_campaign_campaign_identifier_unique" ON public.promotion_campaign USING btree (campaign_identifier) WHERE (deleted_at IS NULL);


--
-- Name: IDX_promotion_campaign_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_promotion_campaign_deleted_at" ON public.promotion_campaign USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_promotion_campaign_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_promotion_campaign_id" ON public.promotion USING btree (campaign_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_promotion_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_promotion_deleted_at" ON public.promotion USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_promotion_id_-71518339; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_promotion_id_-71518339" ON public.order_promotion USING btree (promotion_id);


--
-- Name: IDX_promotion_id_-a9d4a70b; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_promotion_id_-a9d4a70b" ON public.cart_promotion USING btree (promotion_id);


--
-- Name: IDX_promotion_rule_attribute; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_promotion_rule_attribute" ON public.promotion_rule USING btree (attribute);


--
-- Name: IDX_promotion_rule_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_promotion_rule_deleted_at" ON public.promotion_rule USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_promotion_rule_operator; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_promotion_rule_operator" ON public.promotion_rule USING btree (operator);


--
-- Name: IDX_promotion_rule_value_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_promotion_rule_value_deleted_at" ON public.promotion_rule_value USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_promotion_rule_value_promotion_rule_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_promotion_rule_value_promotion_rule_id" ON public.promotion_rule_value USING btree (promotion_rule_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_promotion_status; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_promotion_status" ON public.promotion USING btree (status) WHERE (deleted_at IS NULL);


--
-- Name: IDX_promotion_type; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_promotion_type" ON public.promotion USING btree (type);


--
-- Name: IDX_provider_identity_auth_identity_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_provider_identity_auth_identity_id" ON public.provider_identity USING btree (auth_identity_id);


--
-- Name: IDX_provider_identity_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_provider_identity_deleted_at" ON public.provider_identity USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_provider_identity_provider_entity_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_provider_identity_provider_entity_id" ON public.provider_identity USING btree (entity_id, provider);


--
-- Name: IDX_publishable_key_id_-1d67bae40; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_publishable_key_id_-1d67bae40" ON public.publishable_api_key_sales_channel USING btree (publishable_key_id);


--
-- Name: IDX_refund_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_refund_deleted_at" ON public.refund USING btree (deleted_at);


--
-- Name: IDX_refund_payment_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_refund_payment_id" ON public.refund USING btree (payment_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_refund_reason_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_refund_reason_deleted_at" ON public.refund_reason USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_refund_refund_reason_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_refund_refund_reason_id" ON public.refund USING btree (refund_reason_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_region_country_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_region_country_deleted_at" ON public.region_country USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_region_country_region_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_region_country_region_id" ON public.region_country USING btree (region_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_region_country_region_id_iso_2_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_region_country_region_id_iso_2_unique" ON public.region_country USING btree (region_id, iso_2);


--
-- Name: IDX_region_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_region_deleted_at" ON public.region USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_region_id_1c934dab0; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_region_id_1c934dab0" ON public.region_payment_provider USING btree (region_id);


--
-- Name: IDX_reservation_item_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_reservation_item_deleted_at" ON public.reservation_item USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_reservation_item_inventory_item_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_reservation_item_inventory_item_id" ON public.reservation_item USING btree (inventory_item_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_reservation_item_line_item_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_reservation_item_line_item_id" ON public.reservation_item USING btree (line_item_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_reservation_item_location_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_reservation_item_location_id" ON public.reservation_item USING btree (location_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_return_claim_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_return_claim_id" ON public.return USING btree (claim_id) WHERE ((claim_id IS NOT NULL) AND (deleted_at IS NULL));


--
-- Name: IDX_return_display_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_return_display_id" ON public.return USING btree (display_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_return_exchange_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_return_exchange_id" ON public.return USING btree (exchange_id) WHERE ((exchange_id IS NOT NULL) AND (deleted_at IS NULL));


--
-- Name: IDX_return_id_-31ea43a; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_return_id_-31ea43a" ON public.return_fulfillment USING btree (return_id);


--
-- Name: IDX_return_item_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_return_item_deleted_at" ON public.return_item USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_return_item_item_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_return_item_item_id" ON public.return_item USING btree (item_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_return_item_reason_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_return_item_reason_id" ON public.return_item USING btree (reason_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_return_item_return_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_return_item_return_id" ON public.return_item USING btree (return_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_return_order_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_return_order_id" ON public.return USING btree (order_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_return_reason_value; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_return_reason_value" ON public.return_reason USING btree (value) WHERE (deleted_at IS NULL);


--
-- Name: IDX_sales_channel_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_sales_channel_deleted_at" ON public.sales_channel USING btree (deleted_at);


--
-- Name: IDX_sales_channel_id_-1d67bae40; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_sales_channel_id_-1d67bae40" ON public.publishable_api_key_sales_channel USING btree (sales_channel_id);


--
-- Name: IDX_sales_channel_id_20b454295; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_sales_channel_id_20b454295" ON public.product_sales_channel USING btree (sales_channel_id);


--
-- Name: IDX_sales_channel_id_26d06f470; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_sales_channel_id_26d06f470" ON public.sales_channel_stock_location USING btree (sales_channel_id);


--
-- Name: IDX_service_zone_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_service_zone_deleted_at" ON public.service_zone USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_service_zone_fulfillment_set_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_service_zone_fulfillment_set_id" ON public.service_zone USING btree (fulfillment_set_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_service_zone_name_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_service_zone_name_unique" ON public.service_zone USING btree (name) WHERE (deleted_at IS NULL);


--
-- Name: IDX_shipping_method_adjustment_promotion_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_shipping_method_adjustment_promotion_id" ON public.cart_shipping_method_adjustment USING btree (promotion_id) WHERE ((deleted_at IS NULL) AND (promotion_id IS NOT NULL));


--
-- Name: IDX_shipping_method_cart_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_shipping_method_cart_id" ON public.cart_shipping_method USING btree (cart_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_shipping_method_option_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_shipping_method_option_id" ON public.cart_shipping_method USING btree (shipping_option_id) WHERE ((deleted_at IS NULL) AND (shipping_option_id IS NOT NULL));


--
-- Name: IDX_shipping_method_tax_line_tax_rate_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_shipping_method_tax_line_tax_rate_id" ON public.cart_shipping_method_tax_line USING btree (tax_rate_id) WHERE ((deleted_at IS NULL) AND (tax_rate_id IS NOT NULL));


--
-- Name: IDX_shipping_option_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_shipping_option_deleted_at" ON public.shipping_option USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_shipping_option_id_ba32fa9c; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_shipping_option_id_ba32fa9c" ON public.shipping_option_price_set USING btree (shipping_option_id);


--
-- Name: IDX_shipping_option_provider_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_shipping_option_provider_id" ON public.shipping_option USING btree (provider_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_shipping_option_rule_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_shipping_option_rule_deleted_at" ON public.shipping_option_rule USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_shipping_option_rule_shipping_option_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_shipping_option_rule_shipping_option_id" ON public.shipping_option_rule USING btree (shipping_option_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_shipping_option_service_zone_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_shipping_option_service_zone_id" ON public.shipping_option USING btree (service_zone_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_shipping_option_shipping_profile_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_shipping_option_shipping_profile_id" ON public.shipping_option USING btree (shipping_profile_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_shipping_option_type_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_shipping_option_type_deleted_at" ON public.shipping_option_type USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_shipping_profile_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_shipping_profile_deleted_at" ON public.shipping_profile USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_shipping_profile_id_17a262437; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_shipping_profile_id_17a262437" ON public.product_shipping_profile USING btree (shipping_profile_id);


--
-- Name: IDX_shipping_profile_name_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_shipping_profile_name_unique" ON public.shipping_profile USING btree (name) WHERE (deleted_at IS NULL);


--
-- Name: IDX_single_default_region; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_single_default_region" ON public.tax_rate USING btree (tax_region_id) WHERE ((is_default = true) AND (deleted_at IS NULL));


--
-- Name: IDX_stock_location_address_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_stock_location_address_deleted_at" ON public.stock_location_address USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_stock_location_address_id_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_stock_location_address_id_unique" ON public.stock_location USING btree (address_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_stock_location_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_stock_location_deleted_at" ON public.stock_location USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_stock_location_id_-1e5992737; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_stock_location_id_-1e5992737" ON public.location_fulfillment_provider USING btree (stock_location_id);


--
-- Name: IDX_stock_location_id_-e88adb96; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_stock_location_id_-e88adb96" ON public.location_fulfillment_set USING btree (stock_location_id);


--
-- Name: IDX_stock_location_id_26d06f470; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_stock_location_id_26d06f470" ON public.sales_channel_stock_location USING btree (stock_location_id);


--
-- Name: IDX_store_currency_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_store_currency_deleted_at" ON public.store_currency USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_store_currency_store_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_store_currency_store_id" ON public.store_currency USING btree (store_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_store_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_store_deleted_at" ON public.store USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_tag_value_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_tag_value_unique" ON public.product_tag USING btree (value) WHERE (deleted_at IS NULL);


--
-- Name: IDX_tax_line_item_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_tax_line_item_id" ON public.cart_line_item_tax_line USING btree (item_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_tax_line_shipping_method_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_tax_line_shipping_method_id" ON public.cart_shipping_method_tax_line USING btree (shipping_method_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_tax_provider_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_tax_provider_deleted_at" ON public.tax_provider USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_tax_rate_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_tax_rate_deleted_at" ON public.tax_rate USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_tax_rate_rule_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_tax_rate_rule_deleted_at" ON public.tax_rate_rule USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_tax_rate_rule_reference_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_tax_rate_rule_reference_id" ON public.tax_rate_rule USING btree (reference_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_tax_rate_rule_tax_rate_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_tax_rate_rule_tax_rate_id" ON public.tax_rate_rule USING btree (tax_rate_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_tax_rate_rule_unique_rate_reference; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_tax_rate_rule_unique_rate_reference" ON public.tax_rate_rule USING btree (tax_rate_id, reference_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_tax_rate_tax_region_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_tax_rate_tax_region_id" ON public.tax_rate USING btree (tax_region_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_tax_region_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_tax_region_deleted_at" ON public.tax_region USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_tax_region_parent_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_tax_region_parent_id" ON public.tax_region USING btree (parent_id);


--
-- Name: IDX_tax_region_provider_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_tax_region_provider_id" ON public.tax_region USING btree (provider_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_tax_region_unique_country_nullable_province; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_tax_region_unique_country_nullable_province" ON public.tax_region USING btree (country_code) WHERE ((province_code IS NULL) AND (deleted_at IS NULL));


--
-- Name: IDX_tax_region_unique_country_province; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_tax_region_unique_country_province" ON public.tax_region USING btree (country_code, province_code) WHERE (deleted_at IS NULL);


--
-- Name: IDX_type_value_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_type_value_unique" ON public.product_type USING btree (value) WHERE (deleted_at IS NULL);


--
-- Name: IDX_unique_promotion_code; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_unique_promotion_code" ON public.promotion USING btree (code) WHERE (deleted_at IS NULL);


--
-- Name: IDX_user_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_user_deleted_at" ON public."user" USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_user_email_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_user_email_unique" ON public."user" USING btree (email) WHERE (deleted_at IS NULL);


--
-- Name: IDX_user_preference_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_user_preference_deleted_at" ON public.user_preference USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_user_preference_user_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_user_preference_user_id" ON public.user_preference USING btree (user_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_user_preference_user_id_key_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_user_preference_user_id_key_unique" ON public.user_preference USING btree (user_id, key) WHERE (deleted_at IS NULL);


--
-- Name: IDX_variant_id_17b4c4e35; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_variant_id_17b4c4e35" ON public.product_variant_inventory_item USING btree (variant_id);


--
-- Name: IDX_variant_id_52b23597; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_variant_id_52b23597" ON public.product_variant_price_set USING btree (variant_id);


--
-- Name: IDX_view_configuration_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_view_configuration_deleted_at" ON public.view_configuration USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_view_configuration_entity_is_system_default; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_view_configuration_entity_is_system_default" ON public.view_configuration USING btree (entity, is_system_default) WHERE (deleted_at IS NULL);


--
-- Name: IDX_view_configuration_entity_user_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_view_configuration_entity_user_id" ON public.view_configuration USING btree (entity, user_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_view_configuration_user_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_view_configuration_user_id" ON public.view_configuration USING btree (user_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_workflow_execution_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_workflow_execution_deleted_at" ON public.workflow_execution USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_workflow_execution_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_workflow_execution_id" ON public.workflow_execution USING btree (id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_workflow_execution_run_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_workflow_execution_run_id" ON public.workflow_execution USING btree (run_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_workflow_execution_state; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_workflow_execution_state" ON public.workflow_execution USING btree (state) WHERE (deleted_at IS NULL);


--
-- Name: IDX_workflow_execution_transaction_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_workflow_execution_transaction_id" ON public.workflow_execution USING btree (transaction_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_workflow_execution_workflow_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_workflow_execution_workflow_id" ON public.workflow_execution USING btree (workflow_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_workflow_execution_workflow_id_transaction_id_run_id_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_workflow_execution_workflow_id_transaction_id_run_id_unique" ON public.workflow_execution USING btree (workflow_id, transaction_id, run_id) WHERE (deleted_at IS NULL);


--
-- Name: idx_script_name_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_script_name_unique ON public.script_migrations USING btree (script_name);


--
-- Name: tax_rate_rule FK_tax_rate_rule_tax_rate_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tax_rate_rule
    ADD CONSTRAINT "FK_tax_rate_rule_tax_rate_id" FOREIGN KEY (tax_rate_id) REFERENCES public.tax_rate(id) ON DELETE CASCADE;


--
-- Name: tax_rate FK_tax_rate_tax_region_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tax_rate
    ADD CONSTRAINT "FK_tax_rate_tax_region_id" FOREIGN KEY (tax_region_id) REFERENCES public.tax_region(id) ON DELETE CASCADE;


--
-- Name: tax_region FK_tax_region_parent_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tax_region
    ADD CONSTRAINT "FK_tax_region_parent_id" FOREIGN KEY (parent_id) REFERENCES public.tax_region(id) ON DELETE CASCADE;


--
-- Name: tax_region FK_tax_region_provider_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tax_region
    ADD CONSTRAINT "FK_tax_region_provider_id" FOREIGN KEY (provider_id) REFERENCES public.tax_provider(id) ON DELETE SET NULL;


--
-- Name: application_method_buy_rules application_method_buy_rules_application_method_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.application_method_buy_rules
    ADD CONSTRAINT application_method_buy_rules_application_method_id_foreign FOREIGN KEY (application_method_id) REFERENCES public.promotion_application_method(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: application_method_buy_rules application_method_buy_rules_promotion_rule_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.application_method_buy_rules
    ADD CONSTRAINT application_method_buy_rules_promotion_rule_id_foreign FOREIGN KEY (promotion_rule_id) REFERENCES public.promotion_rule(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: application_method_target_rules application_method_target_rules_application_method_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.application_method_target_rules
    ADD CONSTRAINT application_method_target_rules_application_method_id_foreign FOREIGN KEY (application_method_id) REFERENCES public.promotion_application_method(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: application_method_target_rules application_method_target_rules_promotion_rule_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.application_method_target_rules
    ADD CONSTRAINT application_method_target_rules_promotion_rule_id_foreign FOREIGN KEY (promotion_rule_id) REFERENCES public.promotion_rule(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: capture capture_payment_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.capture
    ADD CONSTRAINT capture_payment_id_foreign FOREIGN KEY (payment_id) REFERENCES public.payment(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: cart cart_billing_address_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cart
    ADD CONSTRAINT cart_billing_address_id_foreign FOREIGN KEY (billing_address_id) REFERENCES public.cart_address(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: cart_line_item_adjustment cart_line_item_adjustment_item_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cart_line_item_adjustment
    ADD CONSTRAINT cart_line_item_adjustment_item_id_foreign FOREIGN KEY (item_id) REFERENCES public.cart_line_item(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: cart_line_item cart_line_item_cart_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cart_line_item
    ADD CONSTRAINT cart_line_item_cart_id_foreign FOREIGN KEY (cart_id) REFERENCES public.cart(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: cart_line_item_tax_line cart_line_item_tax_line_item_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cart_line_item_tax_line
    ADD CONSTRAINT cart_line_item_tax_line_item_id_foreign FOREIGN KEY (item_id) REFERENCES public.cart_line_item(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: cart cart_shipping_address_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cart
    ADD CONSTRAINT cart_shipping_address_id_foreign FOREIGN KEY (shipping_address_id) REFERENCES public.cart_address(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: cart_shipping_method_adjustment cart_shipping_method_adjustment_shipping_method_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cart_shipping_method_adjustment
    ADD CONSTRAINT cart_shipping_method_adjustment_shipping_method_id_foreign FOREIGN KEY (shipping_method_id) REFERENCES public.cart_shipping_method(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: cart_shipping_method cart_shipping_method_cart_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cart_shipping_method
    ADD CONSTRAINT cart_shipping_method_cart_id_foreign FOREIGN KEY (cart_id) REFERENCES public.cart(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: cart_shipping_method_tax_line cart_shipping_method_tax_line_shipping_method_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cart_shipping_method_tax_line
    ADD CONSTRAINT cart_shipping_method_tax_line_shipping_method_id_foreign FOREIGN KEY (shipping_method_id) REFERENCES public.cart_shipping_method(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: credit_line credit_line_cart_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.credit_line
    ADD CONSTRAINT credit_line_cart_id_foreign FOREIGN KEY (cart_id) REFERENCES public.cart(id) ON UPDATE CASCADE;


--
-- Name: customer_address customer_address_customer_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer_address
    ADD CONSTRAINT customer_address_customer_id_foreign FOREIGN KEY (customer_id) REFERENCES public.customer(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: customer_group_customer customer_group_customer_customer_group_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer_group_customer
    ADD CONSTRAINT customer_group_customer_customer_group_id_foreign FOREIGN KEY (customer_group_id) REFERENCES public.customer_group(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: customer_group_customer customer_group_customer_customer_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer_group_customer
    ADD CONSTRAINT customer_group_customer_customer_id_foreign FOREIGN KEY (customer_id) REFERENCES public.customer(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fulfillment fulfillment_delivery_address_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fulfillment
    ADD CONSTRAINT fulfillment_delivery_address_id_foreign FOREIGN KEY (delivery_address_id) REFERENCES public.fulfillment_address(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: fulfillment_item fulfillment_item_fulfillment_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fulfillment_item
    ADD CONSTRAINT fulfillment_item_fulfillment_id_foreign FOREIGN KEY (fulfillment_id) REFERENCES public.fulfillment(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fulfillment_label fulfillment_label_fulfillment_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fulfillment_label
    ADD CONSTRAINT fulfillment_label_fulfillment_id_foreign FOREIGN KEY (fulfillment_id) REFERENCES public.fulfillment(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fulfillment fulfillment_provider_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fulfillment
    ADD CONSTRAINT fulfillment_provider_id_foreign FOREIGN KEY (provider_id) REFERENCES public.fulfillment_provider(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: fulfillment fulfillment_shipping_option_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fulfillment
    ADD CONSTRAINT fulfillment_shipping_option_id_foreign FOREIGN KEY (shipping_option_id) REFERENCES public.shipping_option(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: geo_zone geo_zone_service_zone_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.geo_zone
    ADD CONSTRAINT geo_zone_service_zone_id_foreign FOREIGN KEY (service_zone_id) REFERENCES public.service_zone(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: image image_product_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.image
    ADD CONSTRAINT image_product_id_foreign FOREIGN KEY (product_id) REFERENCES public.product(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: inventory_level inventory_level_inventory_item_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventory_level
    ADD CONSTRAINT inventory_level_inventory_item_id_foreign FOREIGN KEY (inventory_item_id) REFERENCES public.inventory_item(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: notification notification_provider_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notification
    ADD CONSTRAINT notification_provider_id_foreign FOREIGN KEY (provider_id) REFERENCES public.notification_provider(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: order order_billing_address_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."order"
    ADD CONSTRAINT order_billing_address_id_foreign FOREIGN KEY (billing_address_id) REFERENCES public.order_address(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: order_change_action order_change_action_order_change_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_change_action
    ADD CONSTRAINT order_change_action_order_change_id_foreign FOREIGN KEY (order_change_id) REFERENCES public.order_change(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: order_change order_change_order_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_change
    ADD CONSTRAINT order_change_order_id_foreign FOREIGN KEY (order_id) REFERENCES public."order"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: order_credit_line order_credit_line_order_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_credit_line
    ADD CONSTRAINT order_credit_line_order_id_foreign FOREIGN KEY (order_id) REFERENCES public."order"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: order_item order_item_item_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_item
    ADD CONSTRAINT order_item_item_id_foreign FOREIGN KEY (item_id) REFERENCES public.order_line_item(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: order_item order_item_order_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_item
    ADD CONSTRAINT order_item_order_id_foreign FOREIGN KEY (order_id) REFERENCES public."order"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: order_line_item_adjustment order_line_item_adjustment_item_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_line_item_adjustment
    ADD CONSTRAINT order_line_item_adjustment_item_id_foreign FOREIGN KEY (item_id) REFERENCES public.order_line_item(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: order_line_item_tax_line order_line_item_tax_line_item_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_line_item_tax_line
    ADD CONSTRAINT order_line_item_tax_line_item_id_foreign FOREIGN KEY (item_id) REFERENCES public.order_line_item(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: order_line_item order_line_item_totals_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_line_item
    ADD CONSTRAINT order_line_item_totals_id_foreign FOREIGN KEY (totals_id) REFERENCES public.order_item(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: order order_shipping_address_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."order"
    ADD CONSTRAINT order_shipping_address_id_foreign FOREIGN KEY (shipping_address_id) REFERENCES public.order_address(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: order_shipping_method_adjustment order_shipping_method_adjustment_shipping_method_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_shipping_method_adjustment
    ADD CONSTRAINT order_shipping_method_adjustment_shipping_method_id_foreign FOREIGN KEY (shipping_method_id) REFERENCES public.order_shipping_method(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: order_shipping_method_tax_line order_shipping_method_tax_line_shipping_method_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_shipping_method_tax_line
    ADD CONSTRAINT order_shipping_method_tax_line_shipping_method_id_foreign FOREIGN KEY (shipping_method_id) REFERENCES public.order_shipping_method(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: order_shipping order_shipping_order_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_shipping
    ADD CONSTRAINT order_shipping_order_id_foreign FOREIGN KEY (order_id) REFERENCES public."order"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: order_summary order_summary_order_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_summary
    ADD CONSTRAINT order_summary_order_id_foreign FOREIGN KEY (order_id) REFERENCES public."order"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: order_transaction order_transaction_order_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_transaction
    ADD CONSTRAINT order_transaction_order_id_foreign FOREIGN KEY (order_id) REFERENCES public."order"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: payment_collection_payment_providers payment_collection_payment_providers_payment_col_aa276_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment_collection_payment_providers
    ADD CONSTRAINT payment_collection_payment_providers_payment_col_aa276_foreign FOREIGN KEY (payment_collection_id) REFERENCES public.payment_collection(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: payment_collection_payment_providers payment_collection_payment_providers_payment_pro_2d555_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment_collection_payment_providers
    ADD CONSTRAINT payment_collection_payment_providers_payment_pro_2d555_foreign FOREIGN KEY (payment_provider_id) REFERENCES public.payment_provider(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: payment payment_payment_collection_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment
    ADD CONSTRAINT payment_payment_collection_id_foreign FOREIGN KEY (payment_collection_id) REFERENCES public.payment_collection(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: payment_session payment_session_payment_collection_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment_session
    ADD CONSTRAINT payment_session_payment_collection_id_foreign FOREIGN KEY (payment_collection_id) REFERENCES public.payment_collection(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: price_list_rule price_list_rule_price_list_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.price_list_rule
    ADD CONSTRAINT price_list_rule_price_list_id_foreign FOREIGN KEY (price_list_id) REFERENCES public.price_list(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: price price_price_list_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.price
    ADD CONSTRAINT price_price_list_id_foreign FOREIGN KEY (price_list_id) REFERENCES public.price_list(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: price price_price_set_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.price
    ADD CONSTRAINT price_price_set_id_foreign FOREIGN KEY (price_set_id) REFERENCES public.price_set(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: price_rule price_rule_price_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.price_rule
    ADD CONSTRAINT price_rule_price_id_foreign FOREIGN KEY (price_id) REFERENCES public.price(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: product_category product_category_parent_category_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_category
    ADD CONSTRAINT product_category_parent_category_id_foreign FOREIGN KEY (parent_category_id) REFERENCES public.product_category(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: product_category_product product_category_product_product_category_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_category_product
    ADD CONSTRAINT product_category_product_product_category_id_foreign FOREIGN KEY (product_category_id) REFERENCES public.product_category(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: product_category_product product_category_product_product_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_category_product
    ADD CONSTRAINT product_category_product_product_id_foreign FOREIGN KEY (product_id) REFERENCES public.product(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: product product_collection_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product
    ADD CONSTRAINT product_collection_id_foreign FOREIGN KEY (collection_id) REFERENCES public.product_collection(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: product_option product_option_product_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_option
    ADD CONSTRAINT product_option_product_id_foreign FOREIGN KEY (product_id) REFERENCES public.product(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: product_option_value product_option_value_option_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_option_value
    ADD CONSTRAINT product_option_value_option_id_foreign FOREIGN KEY (option_id) REFERENCES public.product_option(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: product_tags product_tags_product_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_tags
    ADD CONSTRAINT product_tags_product_id_foreign FOREIGN KEY (product_id) REFERENCES public.product(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: product_tags product_tags_product_tag_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_tags
    ADD CONSTRAINT product_tags_product_tag_id_foreign FOREIGN KEY (product_tag_id) REFERENCES public.product_tag(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: product product_type_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product
    ADD CONSTRAINT product_type_id_foreign FOREIGN KEY (type_id) REFERENCES public.product_type(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: product_variant_option product_variant_option_option_value_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_variant_option
    ADD CONSTRAINT product_variant_option_option_value_id_foreign FOREIGN KEY (option_value_id) REFERENCES public.product_option_value(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: product_variant_option product_variant_option_variant_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_variant_option
    ADD CONSTRAINT product_variant_option_variant_id_foreign FOREIGN KEY (variant_id) REFERENCES public.product_variant(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: product_variant product_variant_product_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_variant
    ADD CONSTRAINT product_variant_product_id_foreign FOREIGN KEY (product_id) REFERENCES public.product(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: promotion_application_method promotion_application_method_promotion_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.promotion_application_method
    ADD CONSTRAINT promotion_application_method_promotion_id_foreign FOREIGN KEY (promotion_id) REFERENCES public.promotion(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: promotion_campaign_budget promotion_campaign_budget_campaign_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.promotion_campaign_budget
    ADD CONSTRAINT promotion_campaign_budget_campaign_id_foreign FOREIGN KEY (campaign_id) REFERENCES public.promotion_campaign(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: promotion promotion_campaign_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.promotion
    ADD CONSTRAINT promotion_campaign_id_foreign FOREIGN KEY (campaign_id) REFERENCES public.promotion_campaign(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: promotion_promotion_rule promotion_promotion_rule_promotion_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.promotion_promotion_rule
    ADD CONSTRAINT promotion_promotion_rule_promotion_id_foreign FOREIGN KEY (promotion_id) REFERENCES public.promotion(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: promotion_promotion_rule promotion_promotion_rule_promotion_rule_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.promotion_promotion_rule
    ADD CONSTRAINT promotion_promotion_rule_promotion_rule_id_foreign FOREIGN KEY (promotion_rule_id) REFERENCES public.promotion_rule(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: promotion_rule_value promotion_rule_value_promotion_rule_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.promotion_rule_value
    ADD CONSTRAINT promotion_rule_value_promotion_rule_id_foreign FOREIGN KEY (promotion_rule_id) REFERENCES public.promotion_rule(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: provider_identity provider_identity_auth_identity_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.provider_identity
    ADD CONSTRAINT provider_identity_auth_identity_id_foreign FOREIGN KEY (auth_identity_id) REFERENCES public.auth_identity(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: refund refund_payment_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.refund
    ADD CONSTRAINT refund_payment_id_foreign FOREIGN KEY (payment_id) REFERENCES public.payment(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: region_country region_country_region_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.region_country
    ADD CONSTRAINT region_country_region_id_foreign FOREIGN KEY (region_id) REFERENCES public.region(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: reservation_item reservation_item_inventory_item_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reservation_item
    ADD CONSTRAINT reservation_item_inventory_item_id_foreign FOREIGN KEY (inventory_item_id) REFERENCES public.inventory_item(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: return_reason return_reason_parent_return_reason_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.return_reason
    ADD CONSTRAINT return_reason_parent_return_reason_id_foreign FOREIGN KEY (parent_return_reason_id) REFERENCES public.return_reason(id);


--
-- Name: service_zone service_zone_fulfillment_set_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.service_zone
    ADD CONSTRAINT service_zone_fulfillment_set_id_foreign FOREIGN KEY (fulfillment_set_id) REFERENCES public.fulfillment_set(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: shipping_option shipping_option_provider_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shipping_option
    ADD CONSTRAINT shipping_option_provider_id_foreign FOREIGN KEY (provider_id) REFERENCES public.fulfillment_provider(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: shipping_option_rule shipping_option_rule_shipping_option_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shipping_option_rule
    ADD CONSTRAINT shipping_option_rule_shipping_option_id_foreign FOREIGN KEY (shipping_option_id) REFERENCES public.shipping_option(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: shipping_option shipping_option_service_zone_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shipping_option
    ADD CONSTRAINT shipping_option_service_zone_id_foreign FOREIGN KEY (service_zone_id) REFERENCES public.service_zone(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: shipping_option shipping_option_shipping_option_type_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shipping_option
    ADD CONSTRAINT shipping_option_shipping_option_type_id_foreign FOREIGN KEY (shipping_option_type_id) REFERENCES public.shipping_option_type(id) ON UPDATE CASCADE;


--
-- Name: shipping_option shipping_option_shipping_profile_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shipping_option
    ADD CONSTRAINT shipping_option_shipping_profile_id_foreign FOREIGN KEY (shipping_profile_id) REFERENCES public.shipping_profile(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: stock_location stock_location_address_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stock_location
    ADD CONSTRAINT stock_location_address_id_foreign FOREIGN KEY (address_id) REFERENCES public.stock_location_address(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: store_currency store_currency_store_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.store_currency
    ADD CONSTRAINT store_currency_store_id_foreign FOREIGN KEY (store_id) REFERENCES public.store(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

\unrestrict mXgXcjmArXNP3EjK2NthlCC3TC7aDMzrLezhDejxLoL7eJCAfFehi0Lh1uwY7zf

