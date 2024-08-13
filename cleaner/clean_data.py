import pandas as pd
import os

def try_parsing_date(text):
    for fmt in ('%d/%m/%Y', '%Y-%m-%d', '%m/%d/%Y'):
        try:
            return pd.to_datetime(text, format=fmt)
        except (ValueError, TypeError):
            pass
    return pd.to_datetime(text, errors='coerce')

def clean_data(input_file, output_file):
    # Charger les données CSV
    df = pd.read_csv(input_file)

    # 1. Gérer les valeurs manquantes
    df = df.dropna()

    # 2. Supprimer les duplicata
    df = df.drop_duplicates()

    # 3. Filtrer les outliers pour la colonne 'sales'
    Q1 = df['sales'].quantile(0.25)
    Q3 = df['sales'].quantile(0.75)
    IQR = Q3 - Q1
    df = df[~((df['sales'] < (Q1 - 1.5 * IQR)) | (df['sales'] > (Q3 + 1.5 * IQR)))]

    # 4. Uniformiser les formats de données
    for col in ['order_date', 'ship_date']:
        df[col] = df[col].apply(try_parsing_date).dt.strftime('%Y-%m-%d')

    # 5. Corriger les valeurs incorrectes
    df['quantity'] = df['quantity'].abs()

    # Sauvegarder le fichier nettoyé
    df.to_csv(output_file, index=False)

if __name__ == "__main__":
    # Chemins des fichiers définis par les variables d'environnement
    input_file = os.getenv('INPUT_FILE')
    output_file = os.getenv('OUTPUT_FILE')

    # Appeler la fonction de nettoyage
    clean_data(input_file, output_file)
