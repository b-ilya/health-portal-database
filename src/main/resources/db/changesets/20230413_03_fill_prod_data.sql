--liquibase formatted sql

--changeset illiab:20230413_03_fill_prod_data_1 contextFilter:(prod)and(data)
TRUNCATE TABLE users CASCADE;
INSERT INTO
    users (username, password_hash, first_name, last_name, email, super_user)
VALUES
    ('super', crypt('QwfL5R4!xf7ygW@8sJF16u'), 'Super', 'User', 'temp@ema.il', TRUE);
