-- ============================================================
-- Observatoire foncier et ZAN, Grand Avignon
-- Etape 6. Le gisement foncier, les dents creuses d'Avignon
-- On croise le parcellaire et le bati pour trouver les parcelles
-- vides situees a l'interieur du tissu urbain deja construit.
-- Tables sources, referentiels.parcelles_avignon et referentiels.batiments_avignon
-- ============================================================

-- --- Verification rapide avant de lancer ---
-- Les deux tables doivent etre en WGS84, code 4326.
-- SELECT ST_SRID(geom) FROM referentiels.parcelles_avignon LIMIT 1;   -- doit afficher 4326
-- SELECT ST_SRID(geom) FROM referentiels.batiments_avignon LIMIT 1;   -- doit afficher 4326


-- 1. Copies de travail en Lambert 93, le code 2154, avec index spatial.
--    On travaille en metres, c'est indispensable pour mesurer des surfaces.
DROP TABLE IF EXISTS analyses.parcelles_l93;
CREATE TABLE analyses.parcelles_l93 AS
SELECT row_number() OVER () AS pid,
       ST_Transform(geom, 2154) AS geom
FROM referentiels.parcelles_avignon;
CREATE INDEX idx_parc_l93 ON analyses.parcelles_l93 USING gist(geom);

DROP TABLE IF EXISTS analyses.batiments_l93;
CREATE TABLE analyses.batiments_l93 AS
SELECT ST_Transform(geom, 2154) AS geom
FROM referentiels.batiments_avignon;
CREATE INDEX idx_bati_l93 ON analyses.batiments_l93 USING gist(geom);


-- 2. La tache urbaine, l'enveloppe du tissu construit.
--    On dilate chaque batiment de 25 metres et on fusionne le tout.
--    Les batiments proches se rejoignent, ce qui dessine la zone urbaine.
--    Cette requete peut prendre une minute, c'est normal.
DROP TABLE IF EXISTS analyses.tache_urbaine;
CREATE TABLE analyses.tache_urbaine AS
SELECT ST_Union(ST_Buffer(geom, 25)) AS geom
FROM analyses.batiments_l93;
CREATE INDEX idx_tache ON analyses.tache_urbaine USING gist(geom);


-- 3. Les parcelles non baties, aucun batiment ne les touche.
DROP TABLE IF EXISTS analyses.parcelles_non_baties;
CREATE TABLE analyses.parcelles_non_baties AS
SELECT p.pid, p.geom,
       ST_Area(p.geom) / 10000 AS surface_ha
FROM analyses.parcelles_l93 p
WHERE NOT EXISTS (
  SELECT 1 FROM analyses.batiments_l93 b
  WHERE ST_Intersects(p.geom, b.geom)
);
CREATE INDEX idx_pnb ON analyses.parcelles_non_baties USING gist(geom);


-- 4. Les dents creuses.
--    Une parcelle non batie, dont le centre tombe dans la tache urbaine,
--    et d'une taille raisonnable, de 200 metres carres a 1 hectare.
--    On ecarte les mouchoirs de poche et les grandes parcelles agricoles.
DROP TABLE IF EXISTS analyses.dents_creuses;
CREATE TABLE analyses.dents_creuses AS
SELECT p.pid, p.geom, p.surface_ha
FROM analyses.parcelles_non_baties p, analyses.tache_urbaine t
WHERE ST_Within(ST_Centroid(p.geom), t.geom)
  AND p.surface_ha BETWEEN 0.02 AND 1;
CREATE INDEX idx_dc ON analyses.dents_creuses USING gist(geom);


-- 5. Le chiffre cle du projet.
--    Combien de parcelles vides, et combien d'hectares mobilisables
--    a l'interieur de la ville, sans toucher aux terres agricoles.
SELECT count(*)                              AS nb_dents_creuses,
       round(sum(surface_ha)::numeric, 1)    AS ha_mobilisables
FROM analyses.dents_creuses;
