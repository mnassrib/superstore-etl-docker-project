# Dockerfile pour le nettoyage des données
FROM python:3.8-slim

# Définir le répertoire de travail dans le conteneur
WORKDIR /app

# Copier les fichiers nécessaires dans le conteneur
COPY clean_data.py /app/
COPY requirements.txt /app/

# Installer les dépendances Python
RUN pip install --no-cache-dir -r requirements.txt

# Commande par défaut pour exécuter le script Python
CMD ["python", "clean_data.py"]
