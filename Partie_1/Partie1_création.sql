/*TABLE Avion*/

CREATE TABLE AVION (
    id_avion NUMBER PRIMARY KEY,
    modele VARCHAR2(100) not null,
    capacite NUMBER CHECK (capacite > 0) not null,
    type VARCHAR2(50) not null
);

CREATE SEQUENCE seq_avion START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;


CREATE OR REPLACE TRIGGER trg_avion
BEFORE INSERT ON AVION
FOR EACH ROW 
BEGIN
   :NEW.id_avion :=seq_avion.NEXTVAL ;

END;
/
/*TABLE AEROPORT*/
CREATE TABLE AEROPORT (
    id_aeroport NUMBER PRIMARY KEY,
    nom VARCHAR2(100)not null,
    ville VARCHAR2(100)not null,
    pays VARCHAR2(100)not null
);
CREATE SEQUENCE seq_aero START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE OR REPLACE TRIGGER trg_aero
BEFORE INSERT ON AEROPORT
FOR EACH ROW 
BEGIN
 :NEW.id_aeroport :=seq_aero.NEXTVAL ;

END;
/
/*Table vol */
CREATE TABLE VOL (
    id_vol NUMBER PRIMARY KEY,
    date_depart DATE NOT NULL,
    heure_depart TIMESTAMP NOT NULL,
    heure_arrivee TIMESTAMP NOT NULL,
    id_avion NUMBER NOT NULL,
    aeroport_depart NUMBER NOT NULL,
    aeroport_arrivee NUMBER NOT NULL,
    
    CONSTRAINT fk_vol_avion FOREIGN KEY (id_avion) REFERENCES AVION(id_avion),
    CONSTRAINT fk_vol_depart FOREIGN KEY (aeroport_depart) REFERENCES AEROPORT(id_aeroport),
    CONSTRAINT fk_vol_arrivee FOREIGN KEY (aeroport_arrivee) REFERENCES AEROPORT(id_aeroport),
    
    CONSTRAINT chk_date_depart_arrivee CHECK (heure_arrivee > heure_depart),
    CONSTRAINT chk_aeroports_differents CHECK (aeroport_depart <> aeroport_arrivee)
);
CREATE SEQUENCE seq_vol START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE OR REPLACE TRIGGER trg_vol
BEFORE INSERT ON VOL
FOR EACH ROW
BEGIN
   :NEW.id_vol:= seq_vol.NEXTVAL ;
END;
/
/*PASSAGER*/
CREATE TABLE PASSAGER (
    id_passager NUMBER PRIMARY KEY,
    nom VARCHAR2(100) NOT NULL,
    prenom VARCHAR2(100) NOT NULL,
    email VARCHAR2(150) NOT NULL UNIQUE,
    telephone VARCHAR2(20) NOT NULL
);

CREATE SEQUENCE seq_passager START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE OR REPLACE TRIGGER trg_passager
BEFORE INSERT ON PASSAGER
FOR EACH ROW
BEGIN
 :NEW.id_passager:= seq_passager.NEXTVAL;
END;
/
/*EMPLOYE*/
CREATE TABLE EMPLOYE (
    id_employe NUMBER PRIMARY KEY,
    nom VARCHAR2(100) NOT NULL,
    prenom VARCHAR2(100)NOT NULL,
    poste VARCHAR2(100) NOT NULL,
    email VARCHAR2(150) UNIQUE NOT NULL
);

CREATE SEQUENCE seq_employe START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE OR REPLACE TRIGGER trg_employe
BEFORE INSERT ON EMPLOYE
FOR EACH ROW
BEGIN
  :NEW.id_employe:=seq_employe.NEXTVAL ;
END;
/
/*ASSIGNATION_EQUIPAGE*/
CREATE TABLE ASSIGNATION_EQUIPAGE (
    id_vol NUMBER,
    id_employe NUMBER,
    role VARCHAR2(100),
    PRIMARY KEY (id_vol, id_employe),
    CONSTRAINT fk_assign_vol FOREIGN KEY (id_vol) REFERENCES VOL(id_vol),
    CONSTRAINT fk_assign_employe FOREIGN KEY (id_employe) REFERENCES EMPLOYE(id_employe),
    CONSTRAINT chk_role CHECK (role IS NOT NULL)
);

/* RESERVATION*/
CREATE TABLE RESERVATION (
    id_reservation NUMBER PRIMARY KEY,
    id_passager NUMBER not null,
    id_vol NUMBER not null,
    date_reservation DATE not null,
    statut VARCHAR2(50) CHECK (statut IN ('CONFIRMEE', 'ANNULEE', 'EN_ATTENTE')) not null,
    CONSTRAINT fk_reservation_passager FOREIGN KEY (id_passager) REFERENCES PASSAGER(id_passager),
    CONSTRAINT fk_reservation_vol FOREIGN KEY (id_vol) REFERENCES VOL(id_vol)
    
);
CREATE SEQUENCE seq_reservation START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE OR REPLACE TRIGGER trg_reservation
BEFORE INSERT ON RESERVATION
FOR EACH ROW
BEGIN
:NEW.id_reservation:=seq_reservation.NEXTVAL;
END;
/
-- On vérifie la règle (date de reservation < date de départ )
CREATE OR REPLACE TRIGGER trg_check_date_reservation
BEFORE INSERT OR UPDATE ON RESERVATION
FOR EACH ROW
DECLARE
    v_date_depart VOL.date_depart%TYPE;
BEGIN
   
    SELECT date_depart INTO v_date_depart
    FROM VOL
    WHERE id_vol = :NEW.id_vol;
    
    
    IF :NEW.date_reservation > v_date_depart THEN
        RAISE_APPLICATION_ERROR(-20001, 'La date de réservation doit être avant ou égale à la date de départ du vol.');
    END IF;
END;
/
-- BAGAGE 
CREATE TABLE BAGAGE (
    id_bagage NUMBER PRIMARY KEY,
    poids NUMBER NOT NULL, 
    id_reservation NUMBER NOT NULL,
    
    CONSTRAINT fk_bagage_reservation FOREIGN KEY (id_reservation) REFERENCES RESERVATION(id_reservation),
    CONSTRAINT chk_poids_positif CHECK (poids > 0)
);
CREATE SEQUENCE seq_bagage START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE OR REPLACE TRIGGER trg_bagage
BEFORE INSERT ON BAGAGE
FOR EACH ROW
BEGIN
 :NEW.id_bagage:=seq_bagage.NEXTVAL ;
END;
/
--PRESENCE_VOL
CREATE TABLE PRESENCE_VOL (
    id_passager NUMBER NOT NULL,
    id_vol NUMBER NOT NULL,
    etat_presence VARCHAR2(20) NOT NULL,
    
    CONSTRAINT pk_presence_vol PRIMARY KEY (id_passager, id_vol),
    CONSTRAINT fk_presence_passager FOREIGN KEY (id_passager) REFERENCES PASSAGER(id_passager),
    CONSTRAINT fk_presence_vol FOREIGN KEY (id_vol) REFERENCES VOL(id_vol),
    CONSTRAINT chk_etat_presence CHECK (etat_presence IN ('Présent', 'Absent', 'En Attente'))
);

--Utilisateur 
CREATE TABLE UTILISATEUR (
    id_user NUMBER PRIMARY KEY,
    login VARCHAR2(50) NOT NULL UNIQUE,
    mot_de_passe VARCHAR2(100) NOT NULL,
    profil VARCHAR2(30) NOT NULL,
    
    CONSTRAINT chk_profil_utilisateur CHECK (
        profil IN ('Administrateur', 'Agent de réservation', 'Personnel navigant')
    )
);

CREATE SEQUENCE seq_utilisateur START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE OR REPLACE TRIGGER trg_utilisateur
BEFORE INSERT ON UTILISATEUR
FOR EACH ROW
BEGIN
:NEW.id_user:=seq_utilisateur.NEXTVAL ;
END;
/

CREATE  OR REPLACE TRIGGER verif_role_poste
BEFORE INSERT ON ASSIGNATION_EQUIPAGE
FOR EACH ROW
 DECLARE poste_employe VARCHAR(255);
BEGIN
   
    
    -- Récupérer le poste de l'employé en minuscules
    SELECT LOWER(poste) INTO poste_employe
    FROM EMPLOYE
    WHERE id_employe = :new.id_employe;
    
    -- Vérifier que le rôle dans ASSIGNATION_EQUIPAGE correspond au poste de l'employé en minuscules
    IF LOWER(:new.role) <> poste_employe THEN
        RAISE_APPLICATION_ERROR(-20001, 'Le rôle et le poste de l employé doivent être les mêmes.');
    END IF;
END;




