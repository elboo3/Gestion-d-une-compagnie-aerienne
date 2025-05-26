
--Empêcher l’affectation d’un employé à deux vols simultanés
CREATE OR REPLACE TRIGGER  affectation_vol 
BEFORE INSERT ON ASSIGNATION_EQUIPAGE  
FOR EACH ROW 
DECLARE 
date_vol_inserer   vol.date_depart%type ;
date_vol   vol.date_depart%type ;
CURSOR  c is select  v.date_depart   
              from ASSIGNATION_EQUIPAGE  a 
              join vol v on v.ID_VOL=a.ID_VOL 
              where a.ID_EMPLOYE=:new.ID_EMPLOYE;
BEGIN
select date_depart  into date_vol_inserer  from vol  where ID_VOL=:new.ID_VOL;
OPEN c;
LOOP
FETCH c into date_vol ;
EXIT WHEN c%NOTFOUND;
IF date_vol_inserer = date_vol THEN
RAISE_APPLICATION_ERROR(-20001, 'Employé déjà assigné à un vol à cette date.');
END IF;

END LOOP;
end;

insert into assignation_equipage
values(4,3,'Personnel navigant');

--Éviter qu’un passager soit réservé plusieurs fois sur le même vol
CREATE OR REPLACE TRIGGER  reservation_vol
BEFORE INSERT ON RESERVATION 
FOR EACH ROW 
DECLARE
 nb NUMBER ;
BEGIN
select count(*) into nb 
from reservation 
where ID_PASSAGER = :new.ID_PASSAGER and  ID_VOL = :new.ID_VOL;

IF nb <> 0 THEN
RAISE_APPLICATION_ERROR(-20001, 'ce passager déjà effectuer une reservation sur cette vol .');
END IF;
END;

insert into reservation (ID_PASSAGER,ID_VOL,DATE_RESERVATION,STATUT)
values(1,6,TO_DATE('29/04/2025', 'DD/MM/YYYY'),'CONFIRMEE');

select * from vol;
--Création automatique d’un enregistrement de bagage lors d’une réservation.
/* avant de creer cette triger il faut corriger  la containte sur poid lors de la cration de table  de >0 a >=0*/

ALTER TABLE BAGAGE
DROP CONSTRAINT chk_poids_positif;

ALTER TABLE BAGAGE
ADD CONSTRAINT chk_poids_positif CHECK (POIDS >= 0);


CREATE OR REPLACE TRIGGER ajout_bagage 
AFTER INSERT ON RESERVATION 
FOR EACH ROW
BEGIN
INSERT into bagage (POIDS,ID_RESERVATION)
values(50,:new.ID_RESERVATION);
END;


insert into reservation (ID_PASSAGER,ID_VOL,DATE_RESERVATION,STATUT)
values(1,5,TO_DATE('28/04/2025', 'DD/MM/YYYY'),'CONFIRMEE');

select * from bagage;

--S’assurer que les mots de passe utilisateurs sont stockés de manière sécurisée   on va le hasher 
-- d'abord on va modifier le taille de la colone pwrd car hash realise sur 32 octet => 64 caractere
ALTER TABLE utilisateur MODIFY mot_de_passe VARCHAR2(64);

CREATE OR REPLACE FUNCTION hash_sha256(p_input VARCHAR2)
RETURN VARCHAR2
DETERMINISTIC
AS
BEGIN
  RETURN STANDARD_HASH(p_input, 'SHA256');
END;
/
select * from assignation_equipage;















