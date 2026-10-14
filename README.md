# Observatoire de la consommation foncière et du ZAN, Grand Avignon

Un observatoire personnel qui mesure la consommation d'espaces du Grand Avignon, et qui repère le foncier déjà disponible dans la ville, pour construire sans s'étendre.

L'idée est simple. Avant de grignoter des terres agricoles, une ville peut d'abord se construire sur elle-même. Ce projet le montre avec des chiffres, sur seize communes, de 2012 à 2025.

## Ce que montre l'observatoire

- Le Grand Avignon a consommé 522,8 hectares d'espaces entre 2012 et 2025.
- Le rythme est passé de 42,9 hectares par an à 23,6 hectares par an sur la période récente. L'objectif ZAN est de 21,4 hectares par an. Le territoire s'en rapproche.
- À l'intérieur d'Avignon, 124,9 hectares sont mobilisables, soit 1 351 parcelles vides, les dents creuses du tissu urbain. On peut y accueillir des projets sans toucher aux champs.

## Comment c'est construit

La donnée vit dans une base PostgreSQL et PostGIS, administrée avec pgAdmin. Tout le traitement se fait en SQL spatial, puis la cartographie sous QGIS.

1. Création de la base et du schéma.
2. Import des communes du Grand Avignon.
3. Import de la consommation d'espaces, une ligne par commune et par an, de 2012 à 2025.
4. Analyses, le volume consommé et la comparaison des deux périodes face à l'objectif ZAN.
5. Intensité, la part du territoire communal consommée.
6. Dents creuses, le foncier mobilisable, en croisant le cadastre des parcelles et le bâti pour trouver les parcelles vides dans la ville.

## Le dépôt

- `scripts/`, les scripts SQL dans l'ordre, du montage de la base jusqu'au repérage des dents creuses.
- `data/`, les données sources, la consommation d'espaces, les limites communales et le cadastre.
- `carte/`, les cartes produites sous QGIS.
- `graphiques/`, le rythme annuel face à l'objectif ZAN.
- `projetQGIS/`, le projet QGIS pour rejouer les cartes.
- `Poster_observatoire_foncier_Grand_Avignon.pdf`, le poster de synthèse.
- `Note_de_methode_Observatoire_foncier_ZAN.pdf`, la note de méthode.

## Sources

Consommation d'espaces, Cerema et portail national de l'artificialisation des sols. Cadastre PCI, Etalab. Référentiels, IGN. Projection Lambert 93.


Le fichier national brut de consommation d'espaces n'est pas inclus dans le dépôt, il est trop lourd. Il se télécharge sur le portail national de l'artificialisation des sols du Cerema. Les versions filtrées sur le Grand Avignon, elles, sont dans le dossier data.

## Auteur

Victorine Maximilienne Djetcheu Toko, géomaticienne et ingénieure topographe.
Portfolio, https://portfolio-victorine-djetcheu.netlify.app
