CREATE ROLE db_admin;
CREATE ROLE app_developer;
CREATE ROLE business_analyst;
CREATE ROLE read_only_user;

SELECT rolname
FROM pg_roles;


CREATE USER admin_user
WITH PASSWORD 'Admin123!';

CREATE USER developer_user
WITH PASSWORD 'Dev123!';

CREATE USER analyst_user
WITH PASSWORD 'Analyst123!';

CREATE USER viewer_user
WITH PASSWORD 'Viewer123!';

GRANT db_admin
TO admin_user;

GRANT app_developer
TO developer_user;

GRANT business_analyst
TO analyst_user;

GRANT read_only_user
TO viewer_user;


GRANT
SELECT,
INSERT,
UPDATE,
DELETE

ON ALL TABLES IN SCHEMA public

TO app_developer;


GRANT
SELECT

ON ALL TABLES IN SCHEMA public

TO business_analyst;


GRANT
SELECT

ON ALL TABLES IN SCHEMA public

TO read_only_user;


GRANT ALL PRIVILEGES
ON ALL TABLES IN SCHEMA public
TO db_admin;


SELECT
grantee,
table_name,
privilege_type

FROM information_schema.role_table_grants;


REVOKE DELETE

ON orders

FROM app_developer;

SELECT
*
FROM information_schema.role_table_grants
WHERE grantee='app_developer';


SELECT
rolname
FROM pg_roles;


SELECT
grantee,
privilege_type
FROM information_schema.role_table_grants;


