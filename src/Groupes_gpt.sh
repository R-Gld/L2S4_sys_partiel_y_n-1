#!/bin/sh

# Fonction pour obtenir les noms des groupes d'un utilisateur
trouver_groupes() {
    USERNAME=$1
    # Trouver le GID principal de l'utilisateur dans /etc/passwd
    GID_PRINCIPAL=$(grep "^$USERNAME:" /etc/passwd | cut -d: -f4)

    # Trouver le nom du groupe principal à partir de /etc/group
    NOM_GROUPE_PRINCIPAL=$(grep ":$GID_PRINCIPAL:" /etc/group | cut -d: -f1)

    # Trouver les autres groupes auxquels l'utilisateur appartient
    GROUPES=$(grep -E ",$USERNAME,|,$USERNAME$|^$USERNAME," /etc/group | cut -d: -f1)

    # Combiner le groupe principal avec les autres groupes, supprimer les doublons
    echo "$NOM_GROUPE_PRINCIPAL $GROUPES" | tr ' ' '\n' | sort | uniq | tr '\n' ' '
}

# Vérifier si les fichiers /etc/passwd et /etc/group existent et sont lisibles
if [ ! -r /etc/passwd ] || [ ! -r /etc/group ]; then
    echo "Les fichiers nécessaires (/etc/passwd ou /etc/group) sont manquants ou non lisibles"
    exit 1
fi

# Vérifier si le script est appelé avec un seul argument
if [ "$#" -ne 1 ]; then
    echo "Usage : $0 USERNAME"
    exit 1
fi

USERNAME=$1

# Vérifier si l'utilisateur existe dans /etc/passwd
if ! grep -q "^$USERNAME:" /etc/passwd; then
    echo "L'utilisateur $USERNAME n'existe pas."
    exit 1
fi

# Appeler la fonction trouver_groupes et afficher le résultat
GROUPES=$(trouver_groupes $USERNAME)
echo "$USERNAME : $GROUPES"
