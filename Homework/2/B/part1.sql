CREATE TABLE IF NOT EXISTS auth_user (
    id SERIAL PRIMARY KEY,
    username VARCHAR(150),
    last_name VARCHAR(150),
    email VARCHAR(254),
    date_joined TIMESTAMP,
    first_name VARCHAR(150)
);
CREATE TABLE IF NOT EXISTS core_challenger (
    id SERIAL PRIMARY KEY,
    first_name_persian VARCHAR(50),
    last_name_persian VARCHAR(50),
    phone_number VARCHAR(11),
    gender VARCHAR(1),
    status VARCHAR(1),
    user_id INTEGER REFERENCES auth_user(id),
    is_confirmed BOOLEAN,
    shirt_size VARCHAR(4)
);
CREATE TABLE IF NOT EXISTS core_group (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50),
    judge_password TEXT,
    judge_username TEXT,
    level VARCHAR(1)
);
CREATE TABLE IF NOT EXISTS core_membership (
    id SERIAL PRIMARY KEY,
    role VARCHAR(1),
    status VARCHAR(1),
    challenger_id BIGINT REFERENCES core_challenger(id),
    group_id BIGINT REFERENCES core_group(id)
);
