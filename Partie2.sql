show con_name;
select  name from V$PDBS;
Alter SESSION set container =XEPDB1;


--creer utilisateur Agent de réservation
create role agent_reservation;
create user agent_reserv1 IDENTIFIED BY agent123;

GRANT SELECT, INSERT, UPDATE, DELETE ON PASSAGER TO agent_reservation;
GRANT SELECT, INSERT, UPDATE, DELETE ON RESERVATION TO agent_reservation;
GRANT SELECT, INSERT, UPDATE, DELETE ON VOL TO agent_reservation;
GRANT CREATE SESSION TO agent_reservation;
grant agent_reservation to agent_reserv1;

--ADMIN
CREATE USER admin1 IDENTIFIED BY motdepassefort;
GRANT CONNECT, RESOURCE, DBA TO admin1;

--Personnel navigant

--creer une vue pour lister que les vol qui concerne ce agent 
CREATE OR REPLACE VIEW vols_assignés AS
SELECT v.*
FROM ASSIGNATION_EQUIPAGE a
JOIN VOL v ON a.ID_VOL = v.ID_VOL
JOIN EMPLOYE e ON a.ID_EMPLOYE = e.ID_EMPLOYE
WHERE e.email = (SELECT user FROM dual);

--creer une vue pour lister les info des passager relatives aux vols
create or replace view  passager_relat as 
select v.ID_VOL ,p.*
from vol v
join reservation r on r.ID_VOL = v.ID_VOL 
join passager p on p.ID_PASSAGER=r.id_passager
where v.ID_VOL  in ( 
   select id_vol 
   from ASSIGNATION_EQUIPAGE 
   WHERE ID_EMPLOYE = (
    SELECT ID_EMPLOYE 
    FROM EMPLOYE 
    WHERE email = (select user from dual)
)
);
--creer le role 
create role Personnel_navigant;
grant select on vols_assignés to Personnel_navigant;
grant select on passager_relat to Personnel_navigant;
GRANT CREATE SESSION TO Personnel_navigant;


CREATE USER "ahmedbenali@example.tn"
IDENTIFIED BY pers_1
DEFAULT TABLESPACE USERS
TEMPORARY TABLESPACE TEMP;
grant  Personnel_navigant to  "ahmedbenali@example.tn";



