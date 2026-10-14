-- Observatoire de la consommation fonciere et du ZAN, Grand Avignon
-- Etape 1, creation de la base.
-- A lancer apres avoir cree une base nommee observatoire_foncier dans pgAdmin.

CREATE EXTENSION IF NOT EXISTS postgis;

CREATE SCHEMA IF NOT EXISTS referentiels;
CREATE SCHEMA IF NOT EXISTS foncier;
CREATE SCHEMA IF NOT EXISTS analyse;

-- Verification
SELECT postgis_full_version();
