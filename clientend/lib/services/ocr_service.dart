import 'dart:io';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class OcrService {
  final TextRecognizer _textRecognizer = TextRecognizer(
    script: TextRecognitionScript.korean,
  );

  Future<Map<String, dynamic>> processImage(File imageFile) async {
    try {
      final InputImage inputImage = InputImage.fromFile(imageFile);
      final RecognizedText recognizedText = await _textRecognizer.processImage(
        inputImage,
      );
      Map<String, dynamic> result = {};

      int wordIndex = 0;
      for (TextBlock block in recognizedText.blocks) {
        for (TextLine line in block.lines) {
          for (TextElement element in line.elements) {
            result['word_${wordIndex++}'] = element.text;
          }
        }
      }

      return result;
    } catch (e) {
      throw Exception('OCR 처리 중 오류가 발생했습니다: $e');
    } finally {
      _textRecognizer.close();
    }
  }
}
