from flask import Flask, request, jsonify, render_template
import os
from flask_cors import CORS, cross_origin

from cnnClassifier.utils.common import decodeImage
from cnnClassifier.pipeline.prediction import PredictionPipeline

# Set locale (safe for EC2/Linux)
os.environ["LANG"] = "en_US.UTF-8"
os.environ["LC_ALL"] = "en_US.UTF-8"

# Initialize Flask app
app = Flask(__name__, template_folder="templates")
CORS(app)


class ClientApp:
    def __init__(self):
        self.filename = "inputImage.jpg"
        self.classifier = PredictionPipeline(self.filename)


# -------------------- ROUTES --------------------

@app.route("/", methods=["GET"])
@cross_origin()
def home():
    return render_template("index.html")


@app.route("/train", methods=["GET"])
@cross_origin()
def trainRoute():
    # WARNING: not recommended in production
    os.system("python main.py")
    return "Training done successfully!"


@app.route("/predict", methods=["POST"])
@cross_origin()
def predictRoute():
    try:
        image = request.json["image"]
        decodeImage(image, clApp.filename)
        result = clApp.classifier.predict()
        return jsonify(result)
    except Exception as e:
        return jsonify({"error": str(e)}), 500


# -------------------- MAIN --------------------

if __name__ == "__main__":

    # Initialize model safely
    try:
        clApp = ClientApp()
        print("Model loaded successfully")
    except Exception as e:
        print("Model loading failed:", e)
        clApp = None

    # IMPORTANT: 0.0.0.0 + correct port for EC2
    app.run(
        host="0.0.0.0",
        port=8080,
        debug=False
    )
