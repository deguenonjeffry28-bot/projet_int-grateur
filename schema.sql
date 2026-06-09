DROP TABLE IF EXISTS utilisateur CASCADE;
DROP TABLE IF EXISTS competence CASCADE;
DROP TABLE IF EXISTS user_competence CASCADE;
DROP TABLE IF EXISTS user_lacune CASCADE;
DROP TABLE IF EXISTS disponibilite CASCADE;
DROP TABLE IF EXISTS annonce CASCADE;
DROP TABLE IF EXISTS annonce_competence CASCADE;
DROP TABLE IF EXISTS matching CASCADE;
DROP TABLE IF EXISTS conversation CASCADE;
DROP TABLE IF EXISTS message CASCADE;
CREATE TABLE utilisateur (
    id_user SERIAL PRIMARY KEY,

    nom VARCHAR(50) NOT NULL,
    prenom VARCHAR(50) NOT NULL,

    email VARCHAR(100) NOT NULL UNIQUE,
    telephone VARCHAR(20) NOT NULL UNIQUE,

    mot_de_passe VARCHAR(255) NOT NULL,

    photo TEXT,

    filiere VARCHAR(100) NOT NULL,

    niveau VARCHAR(50) NOT NULL,

    bio TEXT, 

    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE competence (
    id_competence SERIAL PRIMARY KEY,

    nom_competence VARCHAR(100) NOT NULL UNIQUE
);


CREATE TABLE user_competence (
    id_user INTEGER,
    id_competence INTEGER,

    PRIMARY KEY (id_user, id_competence),

    FOREIGN KEY (id_user)
        REFERENCES utilisateur(id_user)
        ON DELETE CASCADE,

    FOREIGN KEY (id_competence)
        REFERENCES competence(id_competence)
        ON DELETE CASCADE
);

CREATE TABLE user_lacune (
    id_user INTEGER,
    id_competence INTEGER,

    PRIMARY KEY (id_user, id_competence),

    FOREIGN KEY (id_user)
        REFERENCES utilisateur(id_user)
        ON DELETE CASCADE,

    FOREIGN KEY (id_competence)
        REFERENCES competence(id_competence)
        ON DELETE CASCADE
);

CREATE TABLE disponibilite (
    id_disponibilite SERIAL PRIMARY KEY,

    id_user INTEGER NOT NULL,

    jour VARCHAR(20) NOT NULL,

    heure_debut TIME NOT NULL,

    heure_fin TIME NOT NULL,

    FOREIGN KEY (id_user)
        REFERENCES utilisateur(id_user)
        ON DELETE CASCADE
);

CREATE TABLE annonce (
    id_annonce SERIAL PRIMARY KEY,

    id_user INTEGER NOT NULL,

    titre VARCHAR(200) NOT NULL,

    description TEXT NOT NULL,

    type_annonce VARCHAR(20) NOT NULL,

    format VARCHAR(20) NOT NULL,

    statut VARCHAR(20) DEFAULT 'ACTIVE',

    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (id_user)
        REFERENCES utilisateur(id_user)
        ON DELETE CASCADE
);

CREATE TABLE annonce_competence (
    id_annonce INTEGER,
    id_competence INTEGER,

    PRIMARY KEY (id_annonce, id_competence),

    FOREIGN KEY (id_annonce)
        REFERENCES annonce(id_annonce)
        ON DELETE CASCADE,

    FOREIGN KEY (id_competence)
        REFERENCES competence(id_competence)
        ON DELETE CASCADE
);

CREATE TABLE matching (
    id_matching SERIAL PRIMARY KEY,

    mentor_id INTEGER NOT NULL,

    mentore_id INTEGER NOT NULL,

    score_compatibilite NUMERIC(5,2),

    statut VARCHAR(20) DEFAULT 'EN_ATTENTE',

    date_matching TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (mentor_id)
        REFERENCES utilisateur(id_user)
        ON DELETE CASCADE,

    FOREIGN KEY (mentore_id)
        REFERENCES utilisateur(id_user)
        ON DELETE CASCADE,

    CONSTRAINT chk_users_differents
        CHECK (mentor_id <> mentore_id)

);


CREATE TABLE conversation (
    id_conversation SERIAL PRIMARY KEY,

    id_matching INTEGER NOT NULL,

    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    statut VARCHAR(20) DEFAULT 'ACTIVE',

    FOREIGN KEY (id_matching)
        REFERENCES matching(id_matching)
        ON DELETE CASCADE
);

CREATE TABLE message (
    id_message SERIAL PRIMARY KEY,

    id_conversation INTEGER NOT NULL,

    expediteur_id INTEGER NOT NULL,

    contenu TEXT NOT NULL,

    date_envoi TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    lu BOOLEAN DEFAULT FALSE,

    FOREIGN KEY (id_conversation)
        REFERENCES conversation(id_conversation)
        ON DELETE CASCADE,

    FOREIGN KEY (expediteur_id)
        REFERENCES utilisateur(id_user)
        ON DELETE CASCADE
);