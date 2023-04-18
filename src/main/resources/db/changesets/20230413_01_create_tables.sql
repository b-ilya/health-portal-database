--liquibase formatted sql

--changeset illiab:20230413_01_create_tables_1
DROP TABLE IF EXISTS users CASCADE;
CREATE TABLE users
(
    id            UUID PRIMARY KEY    NOT NULL DEFAULT gen_random_uuid(),
    username      VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(60)         NOT NULL,
    first_name    VARCHAR(100)        NOT NULL,
    last_name     VARCHAR(100)        NOT NULL,
    email         VARCHAR(255)        NOT NULL,
    super_user    BOOLEAN
);

DROP TABLE IF EXISTS auth_tokens CASCADE;
CREATE TABLE auth_tokens
(
    token   UUID PRIMARY KEY NOT NULL,
    user_id UUID UNIQUE NOT NULL,
    issued  TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users (id)

);

DROP TABLE IF EXISTS places CASCADE;
CREATE TABLE places
(
    id      UUID PRIMARY KEY NOT NULL DEFAULT gen_random_uuid(),
    country VARCHAR(100)     NOT NULL,
    city    VARCHAR(100)     NOT NULL,
    zipcode VARCHAR(20)      NOT NULL,
    state   VARCHAR(50),
    CONSTRAINT zipcode_location UNIQUE (country, city, zipcode)
);

DROP TABLE IF EXISTS patients CASCADE;
CREATE TABLE patients
(
    id      UUID PRIMARY KEY NOT NULL DEFAULT gen_random_uuid(),
    first_name VARCHAR(100),
    last_name  VARCHAR(100),
    sex        CHAR(1), -- M (male), F (female), O (other)
    birthday   DATE,
    deleted    BOOLEAN DEFAULT FALSE,
    address    VARCHAR(255),
    place_id   UUID NOT NULL,
    FOREIGN KEY (place_id) REFERENCES places (id)
);

DROP TABLE IF EXISTS patient_records CASCADE;
CREATE TABLE patient_records
(
    id          UUID PRIMARY KEY NOT NULL DEFAULT gen_random_uuid(),
    patient_id  UUID NOT NULL,
    author_id   UUID NOT NULL,
    type        CHAR(1) NOT NULL, -- U for updates (created, info changed, removed), C for comment
    created     TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    modified    TIMESTAMP,
    summary     VARCHAR(100),
    content     VARCHAR,
    FOREIGN KEY (patient_id) REFERENCES patients (id),
    FOREIGN KEY (author_id) REFERENCES users (id)
);
