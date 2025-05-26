

-- Procédure qui cherche tous les vols disponibles entre deux aéroports à une date donnée
create or replace PROCEDURE recherche_vol (date_d in vol.date_depart%TYPE) is

CURSOR c is select  v.ID_VOL ,a.NOM as aero_depart ,b.NOM as aero_arrive
            from vol v  
            join aeroport a  on v.AEROPORT_DEPART= a.ID_AEROPORT
            join aeroport b on v.AEROPORT_ARRIVEE=b.ID_AEROPORT  
            where  DATE_DEPART =date_d;
begin 
for ligne in c 
loop
DBMS_OUTPUT.PUT_LINE('ID_VOL : '||ligne.ID_VOL ||'  aero_depart : '||ligne.aero_depart ||'  aero_arrivé : '||ligne.aero_arrive);
end loop;
end;
/
-- Bloc anonyme pour appeler la procédure avec une date fournie
SET SERVEROUTPUT ON;
DECLARE
    date_vol vol.date_depart%TYPE;
BEGIN
    
    date_vol := TO_DATE('&date_vol', 'DD/MM/YYYY');  
    recherche_vol(date_vol); 
END;
/


/*---------------------------------------------------------------------------------------------------------*/
--Identifier les passagers ayant réservé un vol mais n’ayant pas embarqué.
select p.nom ,p.prenom
from presence_vol v
join passager p  on p.id_passager=v.id_passager
where etat_presence='Absent';

--Calculer le poids total des bagages par réservation
select  id_reservation , sum(poids)
from bagage b 
group by id_reservation;

--Lister les réservations annulées
select * 
from reservation 
where statut='ANNULEE';


--Afficher les membres d’équipage d’un vol donné avec leurs rôles.
create or replace PROCEDURE membre_equipage(p_id_vol in vol.id_vol%type) is
CURSOR c is  select e.nom,e.prenom,e.poste
              from ASSIGNATION_EQUIPAGE a 
              join  employe e on e.ID_EMPLOYE =a.ID_EMPLOYE
              where a.ID_VOL = p_id_vol;

begin 
for ligne in c 
loop
DBMS_OUTPUT.PUT_LINE('nom  : '||ligne.nom ||'  prenom : '||ligne.prenom ||' poste : '||ligne.poste);
end loop;
end;

DECLARE
   id_vol vol.id_vol%TYPE;
BEGIN
    
    id_vol := &id_vol;  
    membre_equipage(id_vol);
END;


--Identifier l’avion le plus utilisé.
select  id_avion,a.modele , count(*) 
from vol v 
join avion a using(id_avion)
group by id_avion ,a.modele
having count(*)=(select max(count(*)) from vol group by id_avion);


--le nombre moyen de bagages par passager
SELECT p.nom, p.prenom, AVG(nb_bagages) AS moyenne_bagages
FROM (
    SELECT r.id_passager, COUNT(b.id_bagage) AS nb_bagages
    FROM reservation r
    JOIN bagage b ON b.id_reservation = r.id_reservation
    GROUP BY  r.id_passager
) nb_bagage
JOIN passager p ON p.id_passager = nb_bagage.id_passager
GROUP BY p.nom, p.prenom;

--le taux d’occupation des vols.
select  r.ID_VOL ,round((count(r.ID_RESERVATION)/a.CAPACITE *100),2) as "ocuppation par %"
from reservation r 
join vol v on v.ID_VOL= r.ID_VOL
join avion a on v.ID_AVION=a.ID_AVION
group by r.ID_VOL,a.CAPACITE;









