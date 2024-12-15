# Application de Gestion de Classe

Ce projet est une application développée en **Flutter** avec **Firebase** comme backend. Elle permet aux étudiants et aux professeurs d'accéder et de gérer les classes de manière intuitive.

## Pré-requis

Avant de commencer, assurez-vous d'avoir les outils suivants installés sur votre machine :

- **Flutter** (dernière version) : [Documentation officielle](https://flutter.dev/docs/get-started/install)
- **Android Studio** ou **Visual Studio Code**
- **SDK Android** correctement configuré
- Un compte Firebase et un projet configuré

## Configuration Firebase

1. Créez un projet sur Firebase : [Firebase Console](https://console.firebase.google.com/).
2. Ajoutez une application Android à votre projet Firebase.
3. Téléchargez le fichier `google-services.json`.
4. Placez ce fichier dans le répertoire suivant de votre projet :  
   `android/app/google-services.json`

Assurez-vous également d'activer les services Firebase nécessaires (ex. : Authentification, Firestore, Cloud Storage).

## Installation et Exécution

### 1. Clonez le Dépôt

Clonez le dépôt Git de ce projet sur votre machine locale :

git clone <URL_du_dépôt>  
cd <nom_du_projet>

### 2. Installez les Dépendances

Récupérez toutes les dépendances du projet en exécutant la commande suivante dans le terminal :

flutter pub get

### 3. Préparez un Appareil ou un Émulateur

- Connectez un appareil Android physique à votre ordinateur (activez le débogage USB sur l'appareil).
- Ou configurez un émulateur Android depuis Android Studio.

### 4. Exécutez l'Application

Lancez l'application avec la commande suivante :

flutter run

Assurez-vous que l'appareil ou l'émulateur est détecté par Flutter avant d'exécuter la commande.

## Fonctionnalités de l'Application

- **Authentification** : Connexion et inscription pour les étudiants et les professeurs.
- **Gestion de classe** : Consultation et modification des informations des classes.
- **Base de données en temps réel** : Synchronisation des données via Firebase.

## Problèmes Courants

- **Connexion Firebase** : Si l'application ne se connecte pas correctement à Firebase, vérifiez que le fichier `google-services.json` est placé au bon endroit.
- **Services Firebase** : Assurez-vous que votre projet Firebase inclut tous les services nécessaires (par exemple, Firestore ou Authentication).
- **Appareil non détecté** : Si aucun appareil n'est détecté par Flutter, utilisez la commande suivante pour vérifier les appareils connectés :

flutter devices

## Ressources Utiles

- [Documentation Flutter](https://flutter.dev/docs)
- [Documentation Firebase](https://firebase.google.com/docs)

---

Ce projet est conçu pour une gestion efficace des classes et une synchronisation fluide des données grâce à Flutter et Firebase.
