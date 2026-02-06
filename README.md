Offline Notes

TP — Persistance locale & Offline-First (Flutter)

1. Présentation du projet

Offline Notes est une application mobile Flutter permettant de gérer des notes entièrement hors connexion.
Elle applique strictement le principe Offline-First, où les données locales sont la source principale de vérité, et où le réseau est considéré comme une optimisation.

L’application permet :

d’ajouter des notes

de consulter la liste des notes

de modifier des notes

de supprimer des notes

Toutes les actions sont immédiates, persistées localement et fonctionnent sans Internet.

2. Objectifs pédagogiques

Ce TP vise à :

mettre en œuvre une persistance locale dans une application mobile Flutter

appliquer le principe Offline-First

concevoir une application robuste hors ligne

préparer une synchronisation différée des données (simulation)

3. Choix de la persistance locale

L’application utilise Hive comme mécanisme de persistance locale.

Justification du choix :

base NoSQL locale clé/valeur

très rapide

simple à configurer

parfaitement adaptée au cache local et aux données métier hors ligne

Conformément au cours :

un seul mécanisme de persistance locale est utilisé

SharedPreferences n’est pas utilisé pour les données métier

aucun serveur réel n’est utilisé

4. Principe Offline-First appliqué

Les règles Offline-First suivantes sont strictement respectées :

toute action utilisateur est enregistrée localement en priorité

l’interface utilisateur est mise à jour immédiatement

le réseau n’est jamais bloquant

aucune donnée ne doit être perdue en mode hors ligne

La synchronisation est différée et simulée, via un bouton dédié.

5. Modèle de données

Chaque note est définie par le modèle suivant :

id : identifiant local

title : titre de la note

content : contenu de la note

status : état de synchronisation

États de synchronisation :

pending : note créée ou modifiée hors ligne

synced : note synchronisée (simulation)

Chaque modification force le statut à pending.

6. Architecture de l’application 

L’architecture respecte une séparation claire des responsabilités, comme demandé dans le cours.

Couches de l’application

Interface utilisateur (UI)

écrans Flutter

widgets

navigation

affichage des statuts

feedback utilisateur 

Logique métier

règles Offline-First

gestion du statut de synchronisation

simulation de synchronisation différée

aucune dépendance à l’UI

Accès aux données

persistance locale via Hive

opérations CRUD

sérialisation des données

Flux général
UI → Service métier → Repository → Stockage local (Hive)


La donnée locale est toujours la source principale.

7. Synchronisation différée (simulation)

Un bouton « Synchroniser » permet de simuler une synchronisation réseau :

une temporisation simule un appel réseau

les notes avec le statut pending passent à synced

un échec peut être simulé aléatoirement

aucune perte de données n’est possible

l’interface ne se bloque jamais

8. Expérience utilisateur (UX)

L’application propose une UX simple et claire :

affichage immédiat des notes

badge visuel indiquant l’état pending ou synced

indicateur de chargement pendant la synchronisation

messages de succès ou d’erreur via SnackBar

écran vide explicite lorsqu’aucune note n’existe

9. Scénarios de validation

Les scénarios suivants sont validés :

ajout d’une note hors ligne → visible immédiatement

redémarrage de l’application → données conservées

modification d’une note → statut repasse à pending

synchronisation → mise à jour des statuts

échec simulé → aucune perte de données

10. Limites actuelles

pas de backend réel

pas de synchronisation réseau réelle

pas de gestion multi-utilisateur

sécurité non implémentée (hors périmètre du TP)

Ces limites sont volontaires et conformes aux consignes du TP.

11. Conclusion

Ce projet met en œuvre une application Flutter respectant :

la persistance locale

le principe Offline-First

une architecture claire et bien séparée

une synchronisation différée simulée

Il répond intégralement aux objectifs pédagogiques du TP.