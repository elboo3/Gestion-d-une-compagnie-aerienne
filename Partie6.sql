show con_name;
SELECT name FROM V$PDBS;
ALTER SESSION SET CONTAINER = XEPDB1;
-- Vue pour les passagers
CREATE OR REPLACE VIEW vue_passagers AS
SELECT id_passager, nom, prenom, email, telephone
FROM PASSAGER;

-- Vue pour les réservations
CREATE OR REPLACE VIEW vue_reservations AS
SELECT id_reservation, id_passager, id_vol, date_reservation, statut
FROM RESERVATION;

-- Vue pour les vols
CREATE OR REPLACE VIEW vue_vols AS
SELECT id_vol, date_depart, heure_depart, heure_arrivee, id_avion, aeroport_depart, aeroport_arrivee
FROM vol;

-- Droits de consultation via les vues
GRANT SELECT ON vue_passagers TO agent_reservation;
GRANT SELECT, INSERT, UPDATE ON vue_reservations TO agent_reservation;
GRANT SELECT ON vue_vols TO agent_reservation;

-- Création de synonymes pour simplifier les requêtes
CREATE public SYNONYM passagers FOR vue_passagers;
CREATE public SYNONYM reservations FOR vue_reservations;
CREATE public SYNONYM vols FOR vue_vols;


