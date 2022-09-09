from flask import Flask, request
import os
import tensorflow as tf
import cv2
import warnings



warnings.simplefilter("ignore")

def model_load():
    """
    Hilfsfunktion um das Modell beim Start von FLask zu laden
    """
    global model
    # Lädt das Modell aus dem Dateipfad
    model = tf.keras.models.load_model("D:/Git-Repo-PJS/PJS_SS_22_KI_Materialbedarfsplanung/backend/model_files/material_model_final.h5")
    print('material_model geladen')



app = Flask(__name__)


@app.route('/predict', methods=['POST'] )
def predict():
    if request.method == 'POST':

        print(request.headers)
        
        # Liest die übermittelte Datei
        file = request.files['file']
        print("gesendetes Bild: "+str(file))
        # Liest den Dateinamen aus
        filename = file.filename 
        # Speichert die Datei ab
        file.save(filename)

        try:
            # Liest das Bild aus der Datei ein
            img = cv2.imread(filename)
        except:
            return {"message": "Nicht unterstütztes Dateiformat. Bitte Datei in .jpg hochladen"}, 500

        # Löscht die Datei
        os.remove(filename)
        # Gibt die Antwort in Stringform zurück
        return ("412.65"), 200


if __name__ == '__main__':
    model_load() 
    app.debug = False 
    app.run(host = "0.0.0.0", port=5000)