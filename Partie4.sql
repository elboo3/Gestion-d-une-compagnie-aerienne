SET SERVEROUTPUT ON;

--Enregistrer une nouvelle réservation (avec création automatique du bagage)

CREATE OR REPLACE PROCEDURE creer_reservation (
    p_id_passager     IN RESERVATION.id_passager%TYPE,
    p_id_vol          IN RESERVATION.id_vol%TYPE,
    p_statut          IN RESERVATION.statut%TYPE DEFAULT 'CONFIRMEE',
    p_poids_bagage    IN BAGAGE.poids%TYPE DEFAULT 0
) AS
    v_id_reservation  RESERVATION.id_reservation%TYPE;
    v_existe          NUMBER := 0;
BEGIN
   
    -- Insertion dans RESERVATION
    INSERT INTO RESERVATION(id_passager, id_vol, date_reservation, statut)
    VALUES ( p_id_passager, p_id_vol, SYSDATE, p_statut)
    RETURNING id_reservation INTO v_id_reservation;  -- Capture the generated id_reservation
    
    -- Création automatique d’un bagage lié
    INSERT INTO BAGAGE(poids, id_reservation)
    VALUES (p_poids_bagage, v_id_reservation); -- même ID si logique simplifiée
    
   
 -- Ajouter une ligne dans la présence vol avec état 'Absent'
    IF p_statut <> 'ANNULEE' THEN
        -- Vérifier si la ligne existe déjà
        SELECT COUNT(*) INTO v_existe
        FROM PRESENCE_VOL
        WHERE id_passager = p_id_passager AND id_vol = p_id_vol;

        IF v_existe = 0 THEN
            INSERT INTO PRESENCE_VOL (id_passager, id_vol, etat_presence) 
            VALUES (p_id_passager, p_id_vol, 'En Attente');
            
        END IF;
    END IF;
    
END;
/
-- Annuler une réservation et mettre à jour les enregistrements concernés

CREATE OR REPLACE PROCEDURE annuler_reservation (
    p_id_reservation IN RESERVATION.id_reservation%TYPE
) AS
BEGIN
    UPDATE RESERVATION
    SET statut = 'ANNULEE'
    WHERE id_reservation = p_id_reservation;

    --  supprimer les bagages ou les désactiver
    DELETE FROM BAGAGE WHERE id_reservation = p_id_reservation;

 -- Supprimer l'enregistrement de présence sur vol
    DELETE FROM PRESENCE_VOL
WHERE (id_passager, id_vol) IN (
    SELECT id_passager, id_vol
    FROM RESERVATION
    WHERE id_reservation = p_id_reservation
);


    
END;
/

--Enregistrer la présence d’un passager à bord
CREATE OR REPLACE PROCEDURE enregistrer_presence (
    p_id_passager IN PRESENCE_VOL.id_passager%TYPE,
    p_id_vol      IN PRESENCE_VOL.id_vol%TYPE,
    p_etat_presence in PRESENCE_VOL.ETAT_PRESENCE%TYPE 
) AS
    v_count NUMBER;
BEGIN
    -- Vérifier si l’enregistrement existe déjà
    SELECT COUNT(*)
    INTO v_count
    FROM PRESENCE_VOL
    WHERE id_passager = p_id_passager AND id_vol = p_id_vol;

    -- S’il existe, faire un UPDATE 
    IF v_count > 0 THEN
        UPDATE PRESENCE_VOL
        SET etat_presence = p_etat_presence
        WHERE id_passager = p_id_passager AND id_vol = p_id_vol;
        
    -- Sinon, faire un INSERT '
    ELSE
        INSERT INTO PRESENCE_VOL (id_passager, id_vol, etat_presence)
        VALUES (p_id_passager, p_id_vol, p_etat_presence);
    END IF;

END;
/


--Obtenir la liste des vols affectés à un employé
CREATE OR REPLACE PROCEDURE afficher_vols_employe (
    p_id_employe IN EMPLOYE.id_employe%TYPE
) AS
    CURSOR c_vols IS
        SELECT v.id_vol, v.date_depart, v.heure_depart
        FROM ASSIGNATION_EQUIPAGE a
        JOIN vol v ON a.id_vol = v.id_vol
        WHERE a.id_employe = p_id_employe;

    v_id_vol VOL.id_vol%TYPE;
    v_date_depart VOL.date_depart%TYPE;
    v_heure_depart VOL.heure_depart%TYPE;
BEGIN
    OPEN c_vols;

    LOOP
        FETCH c_vols INTO v_id_vol, v_date_depart, v_heure_depart;
        EXIT WHEN c_vols%NOTFOUND;

        DBMS_OUTPUT.PUT_LINE('Vol ' || v_id_vol || ' - ' || v_date_depart || ' à ' || v_heure_depart);
    END LOOP;

    CLOSE c_vols;
END;
/


SELECT * from reservation; 
SELECT * from BAGAGE;
SELECT * from presence_vol;
SELECT * FROM passager;
SELECT * FROM vol;
SELECT * from presence_vol;
SELECT * from assignation_equipage;

-- Saisir les données nécessaires
ACCEPT p_id_passager PROMPT 'Entrez l''ID du passager : '
ACCEPT p_id_vol PROMPT 'Entrez l''ID du vol : '
ACCEPT p_poids_bagage PROMPT 'Entrez le poids du bagage : '
ACCEPT p_id_employe PROMPT 'Entrez l''ID de l''employé : '

DECLARE
    v_id_passager     RESERVATION.id_passager%TYPE := &p_id_passager;
    v_id_vol          RESERVATION.id_vol%TYPE := &p_id_vol;
    v_poids_bagage    BAGAGE.poids%TYPE := &p_poids_bagage;
    v_id_employe      EMPLOYE.id_employe%TYPE := &p_id_employe;
    v_id_reservation  RESERVATION.id_reservation%TYPE;
BEGIN
    
    -- Étape 1 : Créer une réservation
    creer_reservation(v_id_passager, v_id_vol, 'CONFIRMEE', v_poids_bagage);
    DBMS_OUTPUT.PUT_LINE('Réservation créée.');
    
  

    -- Récupérer l'ID de la réservation nouvellement créée
    SELECT MAX(id_reservation)
    INTO v_id_reservation
    FROM RESERVATION
    WHERE id_passager = v_id_passager AND id_vol = v_id_vol;

    DBMS_OUTPUT.PUT_LINE('ID réservation : ' || v_id_reservation);

    -- Étape 2 : Enregistrer la présence
    enregistrer_presence(v_id_passager, v_id_vol, 'En Attente');
    DBMS_OUTPUT.PUT_LINE('Présence enregistrée.');

    
    
    -- Étape 3 : Afficher les vols assignés à un employé
    DBMS_OUTPUT.PUT_LINE('--- Vols de l''employé ---');
    afficher_vols_employe(v_id_employe);

    -- Étape 4 : Annuler la réservation
    annuler_reservation(v_id_reservation);
    DBMS_OUTPUT.PUT_LINE('Réservation annulée.');
    
  
END;
/

SELECT * from reservation; 
SELECT * from BAGAGE;
SELECT * from presence_vol;
SELECT * FROM passager;
SELECT * FROM vol;
SELECT * from presence_vol;
SELECT * from assignation_equipage;

