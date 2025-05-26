
INSERT INTO AEROPORT (nom, ville, pays)
VALUES ('Aéroport Tunis-Carthage', 'Tunis', 'Tunisie');

INSERT INTO AEROPORT (nom, ville, pays)
VALUES ('John F. Kennedy International Airport', 'New York', 'USA');

INSERT INTO AEROPORT (nom, ville, pays)
VALUES ('Charles de Gaulle Airport', 'Paris', 'France');

INSERT INTO AEROPORT (nom, ville, pays)
VALUES ('Dubai International Airport', 'Dubai', 'UAE');

INSERT INTO AEROPORT (nom, ville, pays)
VALUES ('Heathrow Airport', 'London', 'UK');


INSERT INTO AVION (modele, capacite, type)
VALUES ('Airbus A320', 180, 'Passagers');


INSERT INTO AVION (modele, capacite, type)
VALUES ('Boeing 747', 350, 'Passagers');

INSERT INTO AVION (modele, capacite, type)
VALUES ('Airbus A380', 500, 'Passagers');

INSERT INTO AVION (modele, capacite, type)
VALUES ('Boeing 737', 200, 'Passagers');

INSERT INTO AVION (modele, capacite, type)
VALUES ('Embraer E190', 100, 'Passagers');


INSERT INTO EMPLOYE (nom, prenom, poste, email)
VALUES ('Jaziri', 'Sami', 'Pilote', 'sami.jaziri@example.tn');

INSERT INTO EMPLOYE (nom, prenom, poste, email)
VALUES ('Chakroun', 'Walid', 'Agent de service', 'walid.chakroun@example.tn');

INSERT INTO EMPLOYE (nom, prenom, poste, email)
VALUES ('Ben Ali', 'Ahmed', 'Personnel navigant', 'ahmed.benali@example.tn');

INSERT INTO EMPLOYE (nom, prenom, poste, email)
VALUES ('Aouadi', 'Rania', 'Agent de service', 'rania.aouadi@example.tn');

INSERT INTO EMPLOYE (nom, prenom, poste, email)
VALUES ('Hadhri', 'Mouna', 'Pilote', 'mouna.hadhri@example.tn');

INSERT INTO EMPLOYE (nom, prenom, poste, email)
VALUES ('Bouazizi', 'Rayen', 'Agent de réservation', 'rayenbouazizi@gmail.tn');
INSERT INTO EMPLOYE (nom, prenom, poste, email)
VALUES ('Gabsi', 'Abdrrahmane', 'Agent de réservation', 'gabsiabdou@gmail.tn');


INSERT INTO PASSAGER (nom, prenom, email, telephone)
VALUES ('Ben Ali', 'Ahmed', 'ahmed.benali@example.tn', '53617326');

INSERT INTO PASSAGER (nom, prenom, email, telephone)
VALUES ('Jaziri', 'Sami', 'sami.jaziri@example.tn', '52500049');

INSERT INTO PASSAGER (nom, prenom, email, telephone)
VALUES ('Hadhri', 'Mouna', 'mouna.hadhri@example.tn', '21521049');

INSERT INTO PASSAGER (nom, prenom, email, telephone)
VALUES ('Chakroun', 'Walid', 'walid.chakroun@example.tn', '98765432');

INSERT INTO PASSAGER (nom, prenom, email, telephone)
VALUES ('Aouadi', 'Rania', 'rania.aouadi@example.tn', '25678901');


-- Vol 1 : Départ de l'Aéroport Tunis-Carthage vers l'Aéroport John F. Kennedy
INSERT INTO VOL (date_depart, heure_depart, heure_arrivee, id_avion, aeroport_depart, aeroport_arrivee)
VALUES (TO_DATE('2025-05-01', 'YYYY-MM-DD'), TO_TIMESTAMP('2025-05-01 08:00:00', 'YYYY-MM-DD HH24:MI:SS'), 
        TO_TIMESTAMP('2025-05-01 14:00:00', 'YYYY-MM-DD HH24:MI:SS'), 1, 1, 2);

-- Vol 2 : Départ de l'Aéroport Tunis-Carthage vers l'Aéroport Charles de Gaulle
INSERT INTO VOL (date_depart, heure_depart, heure_arrivee, id_avion, aeroport_depart, aeroport_arrivee)
VALUES (TO_DATE('2025-05-02', 'YYYY-MM-DD'), TO_TIMESTAMP('2025-05-02 10:00:00', 'YYYY-MM-DD HH24:MI:SS'), 
        TO_TIMESTAMP('2025-05-02 12:30:00', 'YYYY-MM-DD HH24:MI:SS'), 2, 1, 3);

-- Vol 3 : Départ de l'Aéroport Tunis-Carthage vers l'Aéroport Dubai International
INSERT INTO VOL (date_depart, heure_depart, heure_arrivee, id_avion, aeroport_depart, aeroport_arrivee)
VALUES (TO_DATE('2025-05-01', 'YYYY-MM-DD'), TO_TIMESTAMP('2025-05-03 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), 
        TO_TIMESTAMP('2025-05-03 21:00:00', 'YYYY-MM-DD HH24:MI:SS'), 3, 1, 4);

-- Vol 4 : Départ de l'Aéroport Tunis-Carthage vers l'Aéroport Heathrow
INSERT INTO VOL (date_depart, heure_depart, heure_arrivee, id_avion, aeroport_depart, aeroport_arrivee)
VALUES (TO_DATE('2025-05-04', 'YYYY-MM-DD'), TO_TIMESTAMP('2025-05-04 06:00:00', 'YYYY-MM-DD HH24:MI:SS'), 
        TO_TIMESTAMP('2025-05-04 08:30:00', 'YYYY-MM-DD HH24:MI:SS'), 4, 1, 5);

-- Vol 5 : Départ de l'Aéroport John F. Kennedy vers l'Aéroport Tunis-Carthage
INSERT INTO VOL (date_depart, heure_depart, heure_arrivee, id_avion, aeroport_depart, aeroport_arrivee)
VALUES (TO_DATE('2025-05-05', 'YYYY-MM-DD'), TO_TIMESTAMP('2025-05-05 10:00:00', 'YYYY-MM-DD HH24:MI:SS'), 
        TO_TIMESTAMP('2025-05-05 16:00:00', 'YYYY-MM-DD HH24:MI:SS'), 5, 2, 1);
select *from vol;


INSERT INTO RESERVATION (id_passager, id_vol, date_reservation, statut)
VALUES (1, 1, SYSDATE, 'CONFIRMEE');

INSERT INTO RESERVATION (id_passager, id_vol, date_reservation, statut)
VALUES (2, 2, SYSDATE, 'CONFIRMEE');

INSERT INTO RESERVATION (id_passager, id_vol, date_reservation, statut)
VALUES (3, 3, SYSDATE, 'EN_ATTENTE');

INSERT INTO RESERVATION (id_passager, id_vol, date_reservation, statut)
VALUES (4, 4, SYSDATE, 'ANNULEE');

INSERT INTO RESERVATION (id_passager, id_vol, date_reservation, statut)
VALUES (5, 5, SYSDATE, 'CONFIRMEE');


INSERT INTO BAGAGE (poids, id_reservation)
VALUES (20, 1);

INSERT INTO BAGAGE (poids, id_reservation)
VALUES (15, 2);

INSERT INTO BAGAGE (poids, id_reservation)
VALUES (30, 3);

INSERT INTO BAGAGE (poids, id_reservation)
VALUES (25, 4);

INSERT INTO BAGAGE (poids, id_reservation)
VALUES (10, 5);



INSERT INTO PRESENCE_VOL (id_passager, id_vol, etat_presence)
VALUES (1, 1, 'Présent');

INSERT INTO PRESENCE_VOL (id_passager, id_vol, etat_presence)
VALUES (2, 2, 'Absent');

INSERT INTO PRESENCE_VOL (id_passager, id_vol, etat_presence)
VALUES (3, 3, 'En Attente');

INSERT INTO PRESENCE_VOL (id_passager, id_vol, etat_presence)
VALUES (4, 4, 'Absent');

INSERT INTO PRESENCE_VOL (id_passager, id_vol, etat_presence)
VALUES (5, 5, 'Présent');



insert into assignation_equipage
values(1,1,'Pilote');
insert into assignation_equipage
values(1,3,'Personnel navigant');
insert into assignation_equipage
values(1,6,'Agent de réservation');
insert into assignation_equipage
values(2,5,'Pilote');
insert into assignation_equipage
values(2,3,'Personnel navigant');
INSERT INTO UTILISATEUR (login, mot_de_passe, profil)
VALUES ('admin', 'password123', 'Administrateur');


INSERT INTO UTILISATEUR (login, mot_de_passe, profil)
VALUES ('agent_reservation1', 'password456', 'Agent de réservation');


INSERT INTO UTILISATEUR (login, mot_de_passe, profil)
VALUES ('pilote_tunis', 'password789', 'Personnel navigant');


INSERT INTO UTILISATEUR (login, mot_de_passe, profil)
VALUES ('agent_reservation2', 'password321', 'Agent de réservation');


INSERT INTO UTILISATEUR (login, mot_de_passe, profil)
VALUES ('pilote_usa', 'password654', 'Personnel navigant');





