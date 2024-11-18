# Le livret libertaire

par La Corvina et LoskrAES

## Dépendance

### Debian et dérivé

```sh
sudo apt update
sudo apt install texlive-full kramdown make git
```

## Construire les PDFs

```sh
git clone https://github.com/loskraes/TeX-le-livret-libertaire.git
cd TeX-le-livret-libertaire
make all
```

Pour aller plus vite, si vous avez un processeur avec plusieurs cœurs (ici 8) :
```sh
make all -j8
```

Si il y a des erreurs de compilations, la commande suivante vous permet de retrouver un environment propre:
```sh
make dist-clean
make all
```

### GitHub Action (création automatique des PDF par GitHub)

Lorsque de nouveau changement sont mis sur github, github construit automatiquement les PDFs (cela prends quelques minutes) et permet de les téléchargers <https://github.com/loskraes/TeX-le-livret-libertaire/actions/workflows/latexmk.yml>.
Les PDFs sont disponible dans un fichier zip pour une durée limitée (env. 90 jours).

## Structure du dépôt git

### Fichier source

Les fichiers sources contenant le texte qui se trouve dans les pdfs se trouve dans `./src/`.
Le fichier markdown (`.md`) qui ci trouve sont automatiquement convertis en LaTeX (`.tex`), si le fichier LaTeX existe déjà il n'est pas écraser, ce qui conserve les corrections.

Le fichier `./main.tex` inclus les fichier se trouvant dans le dossier `./src/`, lors de l'ajout et de la suppression d'une source, il faut adapter ce fichier.

Le dossier `./template/` contient les fichiers de structure des documents.
Les `.template` permet de construire un PDF à partir des sources.
Les `.transform` permet de transformer un PDF en un autre format (p.ex. en booklet)

### Construction

La construction se pilote avec `make` qui lit sa configuration dans `./Makefile`.
Toute la construction des PDF se passe dans `./build/`.
Les fichiers PDFs produits sont automatiquement copié dans le dossier `./pdf/`

### Connexe

Dans le dossier `./.github/` se trouve les fichiers de configuration pour les actions GitHub.

