--liquibase formatted sql

--changeset illiab:20230413_01_configure_1
CREATE OR REPLACE FUNCTION crypt(password TEXT) RETURNS TEXT LANGUAGE SQL AS 'SELECT crypt(password, gen_salt(''bf'', 10));';
