-- Etape 2, import de la consommation d'espaces du Grand Avignon.
-- Surfaces en hectares. Une ligne par commune et par annee, de 2012 a 2025.

DROP TABLE IF EXISTS foncier.conso_annuelle;
CREATE TABLE foncier.conso_annuelle (
  idcom         text,
  nom           text,
  departement   text,
  annee         integer,
  naf_total_ha  numeric,
  habitat_ha    numeric,
  activite_ha   numeric,
  mixte_ha      numeric,
  inconnu_ha    numeric,
  ferroviaire_ha numeric,
  routier_ha    numeric
);

-- Import du fichier. Deux facons.
--
-- Facon 1, dans pgAdmin, la plus simple.
-- Clic droit sur la table foncier.conso_annuelle, puis Import/Export Data.
-- Onglet Import. Fichier, data/conso_grand_avignon_annuel.csv.
-- Format csv. Header oui. Delimiteur virgule. Encodage UTF8. Lance.
--
-- Facon 2, en ligne de commande psql, adapte le chemin.
-- \copy foncier.conso_annuelle FROM 'data/conso_grand_avignon_annuel.csv' WITH (FORMAT csv, HEADER true);

-- Verification
SELECT count(*) AS lignes, count(distinct idcom) AS communes FROM foncier.conso_annuelle;
