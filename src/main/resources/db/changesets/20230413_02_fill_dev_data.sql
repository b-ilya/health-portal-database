--liquibase formatted sql

--changeset illiab:20230413_02_fill_dev_data_1 contextFilter:(dev)and(data)
INSERT INTO users (id, username, password_hash, first_name, last_name, email, super_user)
VALUES (DEFAULT, 'super', crypt('pa$5M0rd'), 'Super', 'User', 'temp@ema.il', TRUE);

--changeset illiab:20230413_02_fill_dev_data_2 contextFilter:(dev)and(data)
SET DATESTYLE TO 'ISO, YMD';

WITH tmp (first_name, last_name, sex, birthday, address, city, country, zipcode, place_id) AS
(
    VALUES
        ('John', 'Doe', 'M', '1970/02/15'::date, '13, Friday str., apt 666', 'Silent Hill', 'US', '126812', gen_random_uuid()),
        ('Jane', 'Dove', 'F', '1970/02/05'::date, '12, Sunday av., apt 777', 'Loud Hill', 'US', '285011', gen_random_uuid())
),
new_places AS
(
    INSERT INTO places (id, country, city, zipcode)
    SELECT tmp.place_id, tmp.country, tmp.city, tmp.zipcode
    FROM tmp
    RETURNING ''
)
INSERT
INTO patients (first_name, last_name, sex, birthday, address, place_id)
SELECT tmp.first_name, tmp.last_name, tmp.sex, tmp.birthday, tmp.address, tmp.place_id
FROM tmp;
