# Adoption de MADR pour la documentation des décisions d'architecture

* Statut : Accepté
* Décideurs : James
* Date : 2026-07-30

## Contexte et Problème

CursorWow est un addon WoW léger et sans dépendances externes. Dès la conception, des choix architecturaux importants ont été faits (par ex., utiliser uniquement l'API WoW native au lieu d'Ace3) pour maintenir cette légèreté. Sans documentation formelle de ces décisions, le risque existe de :
- Réinventer ou relitiger des options déjà rejetées
- Perdre le contexte des contraintes et des trade-offs
- Accumuler une dette de compréhension entre les sessions de développement

Un format structuré pour enregistrer les décisions futures aide à maintenir la cohérence du projet et à justifier les choix architecturaux.

## Options envisagées

* **Option 1 :** Adopter MADR (Markdown Any Decision Record) pour documenter les décisions futures
* **Option 2 :** Conserver une documentation ad-hoc (commentaires éparpillés, README informel)

## Évaluation des options

### Option 1 : Adopter MADR
* **Bon :** Format structuré et versionnés (les ADRs sont du code source); chaque décision reçoit son contexte, options, justification et conséquences; facile à rechercher et à relire; invite à penser par alternatives; crée une histoire décisionnelle du projet.
* **Moins bon :** Demande de la discipline pour documenter avant ou immédiatement après une décision; un overhead léger pour les petits changements.

### Option 2 : Documentation ad-hoc
* **Bon :** Rapide et flexible; pas de structure imposée.
* **Moins bon :** Les décisions se perdent dans les commentaires ou les discussions informelles; impossible de retracer "pourquoi avons-nous rejeté Ace3?"; chaque nouvelle personne (ou Claude) redécouvre les mêmes questions; accumulation de dette intellectuelle.

## Décision retenue

Nous choisissons l'**Option 1 (MADR)** car un addon léger dépend d'une clarté architecturale forte. Documenter les décisions dans `docs/adr/` en français permet de justifier les choix (par ex., API native WoW vs. Ace3), d'éviter les re-litigations, et de constituer une référence claire pour les phases futures du projet.

### Conséquences

* **Positives :** Transparence architecturale; base pour justifier les trade-offs; référence facile à auditer; discipline décisionnelle; intégration naturelle au workflow de développement comme partie du code source.
* **Négatives :** Discipline requise pour documenter; overhead minimal à chaque décision architecturale; les ADRs obsolètes doivent être marquées (l'histoire reste visible mais clairement fermée).
