@'
# Shop & Recipes

Application Flutter faite dans le cadre du projet "App connectée avec backend réel". Elle affiche des produits, des recettes et des posts venant de l'API DummyJSON, avec une connexion par JWT et un cache local pour continuer à lire les données sans réseau.

## API utilisée

J'ai choisi [DummyJSON](https://dummyjson.com) parce qu'elle ne demande pas de clé et qu'elle propose un vrai login JWT avec refresh token. Endpoints utilisés : `/auth/login`, `/auth/refresh`, `/auth/me`, `/users/add`, `/products`, `/recipes` et `/posts`.

Limite à connaître : DummyJSON ne sauvegarde pas les nouveaux utilisateurs. L'inscription appelle bien `/users/add` mais le compte créé n'existe pas vraiment et ne peut pas se connecter. Pour tester, il faut utiliser le compte `emilys` / `emilyspass`.

## Architecture

J'ai suivi une organisation par fonctionnalité (feature-first). Chaque feature (`auth`, `products`, `recipes`, `posts`) est découpée en trois dossiers : `domain` (modèles et interface du repository), `data` (implémentation qui appelle l'API et le cache) et `presentation` (pages et providers Riverpod). Ce qui est partagé est dans `lib/core` : client Dio, intercepteur, stockage du token, cache et gestion des erreurs.

Le chemin d'une donnée : page, provider, repository, puis API ou cache.

Le principe du repository est le même pour les trois listes (classe `CachedFetcher`) :

1. S'il y a du réseau, on appelle l'API et on enregistre la réponse dans Hive.
2. S'il n'y a pas de réseau ou que l'appel échoue, on lit le cache et l'écran affiche un bandeau "Données hors-ligne".
3. S'il n'y a ni réseau ni cache, on affiche un message d'erreur avec un bouton Réessayer.

L'intercepteur Dio ajoute le token à chaque requête. Si le serveur répond 401, il essaie `/auth/refresh`, rejoue la requête, et déconnecte l'utilisateur si le refresh échoue.

## Choix techniques

Dio pour le réseau (les intercepteurs sont pratiques), Riverpod pour l'état, Hive pour le cache (pas de génération de code), flutter_secure_storage pour les tokens, connectivity_plus pour détecter le réseau, mocktail pour les tests.

## Lancer le projet

Aucune clé à configurer.

    flutter pub get
    flutter run -d chrome

Sur Android, `minSdk` doit être au moins 23 (exigence de flutter_secure_storage) et la permission INTERNET doit être dans `AndroidManifest.xml`.

## Tests

    flutter test

Il y a 6 tests sur la couche repository : produits en ligne, hors-ligne avec cache, hors-ligne sans cache, repli sur le cache quand l'API échoue, et login réussi / refusé.

## Ce qui reste à améliorer

Les images ne s'affichent pas hors-ligne (seules les données JSON sont en cache), il n'y a pas de pagination et le refresh token n'est pas couvert par un test automatique.
'@ | Set-Content README.md -Encoding utf8