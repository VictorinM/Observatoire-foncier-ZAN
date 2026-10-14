-- Etape 3, premieres analyses de l'observatoire. Surfaces en hectares.

-- 1. Consommation totale par commune, du plus gros au plus petit.
SELECT nom, round(sum(naf_total_ha),1) AS conso_totale_ha
FROM foncier.conso_annuelle
GROUP BY nom
ORDER BY conso_totale_ha DESC;

-- 2. Rythme annuel de toute l'agglomeration.
SELECT annee, round(sum(naf_total_ha),1) AS conso_ha
FROM foncier.conso_annuelle
GROUP BY annee
ORDER BY annee;

-- 3. Part habitat et part activite, par commune.
SELECT nom,
       round(sum(habitat_ha),1)  AS habitat_ha,
       round(sum(activite_ha),1) AS activite_ha
FROM foncier.conso_annuelle
GROUP BY nom
ORDER BY nom;

-- 4. Indicateur ZAN. Comparaison des deux periodes.
-- La loi vise a reduire de moitie la consommation 2021-2031 par rapport a 2011-2021.
SELECT
  round(sum(naf_total_ha) FILTER (WHERE annee BETWEEN 2012 AND 2021),1) AS periode_2011_2021_ha,
  round(sum(naf_total_ha) FILTER (WHERE annee BETWEEN 2022 AND 2025),1) AS periode_2021_2025_ha
FROM foncier.conso_annuelle;

-- 5. Vue pour la carto QGIS. La geometrie des communes, plus la consommation totale.
-- Dans QGIS, ajoute cette vue et choisis le champ code comme identifiant unique.
CREATE OR REPLACE VIEW analyses.v_conso_commune AS
SELECT c.code,
       c.nom,
       c.geom,
       round(sum(a.naf_total_ha),1)  AS conso_totale_ha,
       round(sum(a.habitat_ha),1)    AS habitat_ha,
       round(sum(a.activite_ha),1)   AS activite_ha
FROM referentiels.communes c
JOIN foncier.conso_annuelle a ON a.idcom = c.code
GROUP BY c.code, c.nom, c.geom;
