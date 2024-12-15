[![Review Assignment Due Date](https://classroom.github.com/assets/deadline-readme-button-24ddc0f5d75046c5622901739e7c5dd533143b0c8e959d652212380cedb1ea36.svg)](https://classroom.github.com/a/rCJfMrtv)

# Règles implémentées

```plaintext
rules_version = '2';

service cloud.firestore {
  match /databases/{database}/documents {

    // Fonction pour vérifier si l'utilisateur est un administrateur
    function isAdmin() {
      return request.auth != null &&
             get(/databases/$(database)/documents/utilisateurs/$(request.auth.uid)).data.type_user == "Admin";
    }

    // Fonction pour vérifier si l'utilisateur est un enseignant
    function isTeacher() {
      return request.auth != null &&
             get(/databases/$(database)/documents/utilisateurs/$(request.auth.uid)).data.type_user == "prof";
    }

    // Règle pour autoriser la lecture et l'écriture pour un utilisateur spécifique
    match /utilisateurs/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }

    // Règles pour les opérations des administrateurs sur les utilisateurs
    match /utilisateurs/{document=**} {
      allow read, write, create: if isAdmin();
    }

    // Règles pour les opérations des enseignants sur les utilisateurs
    match /utilisateurs/{document=**} {
      allow read: if isTeacher();
    }

    // Règles pour les opérations des administrateurs sur les classes
    match /classes/{document=**} {
      allow read, write, create: if isAdmin();
    }

    // Règles pour les opérations des enseignants sur les classes
    match /classes/{document=**} {
      allow read: if isTeacher();
    }

    // Définition des règles pour d'autres collections/documents si nécessaire
    // match /autre_collection/{document=**} {
    //   règles d'accès ici
    // }

  }
}
```

# Structure de la base de données utilisée.

## Database (utilisateurs)

### Subcollection (uid)

### Document

<ul>
    <li>courielle</li>
    <li>image_url</li>
    <li>matricule</li>
    <li>nom</li>
    <li>prenom</li>
    <li>type_user</li>
    <p>le type est soit: etudiant,prof,Admin</p>
</ul>

## Database (classes)

### Subcollection (courseNumber)

### Document

<ul>
    <li>courseNumber</li>
    <li>groupNumber</li>
    <li>periods(tableau)
        <ol>
            <li>startTime</li>
            <li>endTIme</li>
            <li>day</li>
        </ol>
    </li>
    <li>students(tableau de nom et prenom)</li>
    <li>teacher(matricule)</li>
</ul>

## Internalisation dans la page de connexion et page profile 1/2 

### Mais la logic est la :).
