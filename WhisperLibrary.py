import whisper

class WhisperLibrary:

    def __init__(self):
        self.model = None
        return

    def load_model(self, size:str):
        self.model = whisper.load_model(size)

    def transcribe(self, path:str):
        return self.model.transcribe(path)
