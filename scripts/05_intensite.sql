-- Carte 2, intensite de consommation.
-- On rapporte la consommation totale a la surface de la commune.
-- Resultat, le pourcentage du territoire communal consomme entre 2012 et 2025.

CREATE OR REPLACE VIEW analyses.v_conso_intensite AS
SELECT
  c.code,
  c.nom,
  c.geom,
  round( (ST_Area(ST_Transform(c.geom, 2154)) / 10000.0)::numeric , 1) AS surface_ha,
  round( sum(a.naf_total_ha)::numeric , 1) AS conso_totale_ha,
  round( ( sum(a.naf_total_ha) / (ST_Area(ST_Transform(c.geom, 2154)) / 10000.0) * 100 )::numeric , 2) AS intensite_pct
FROM referentiels.communes c
JOIN foncier.conso_annuelle a ON a.idcom = c.code
GROUP BY c.code, c.nom, c.geom;

-- Classement par intensite, du plus fort au plus faible.
SELECT nom, surface_ha, conso_totale_ha, intensite_pct
FROM analyses.v_conso_intensite
ORDER BY intensite_pct DESC;
