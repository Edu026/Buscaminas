import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart'; // per a 'CustomPainter'
import 'app_data.dart';

// S'encarrega del dibuix personalitzat del joc
class WidgetTresRatllaPainter extends CustomPainter {
  final AppData appData;

  WidgetTresRatllaPainter(this.appData);

  // Dibuixa les linies del taulell
  void drawBoardLines(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 5.0;

    // Definim els punts on es creuaran les línies verticals

    for (var i = 0; i < int.parse(appData.taulell); i++) {
      canvas.drawLine(
          Offset(i * size.width / int.parse(appData.taulell), 0),
          Offset(i * size.width / int.parse(appData.taulell), size.height),
          paint);

      canvas.drawLine(
          Offset(0, i * size.height / int.parse(appData.taulell)),
          Offset(size.width, i * size.height / int.parse(appData.taulell)),
          paint);
    }
  }

  // Dibuixa la imatge centrada a una casella del taulell
  void drawImage(Canvas canvas, ui.Image image, double x0, double y0, double x1,
      double y1) {
    double dstWidth = x1 - x0;
    double dstHeight = y1 - y0;

    double imageAspectRatio = image.width / image.height;
    double dstAspectRatio = dstWidth / dstHeight;

    double finalWidth;
    double finalHeight;

    if (imageAspectRatio > dstAspectRatio) {
      finalWidth = dstWidth;
      finalHeight = dstWidth / imageAspectRatio;
    } else {
      finalHeight = dstHeight;
      finalWidth = dstHeight * imageAspectRatio;
    }

    double offsetX = x0 + (dstWidth - finalWidth) / 2;
    double offsetY = y0 + (dstHeight - finalHeight) / 2;

    final srcRect =
        Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble());
    final dstRect = Rect.fromLTWH(offsetX, offsetY, finalWidth, finalHeight);

    canvas.drawImageRect(image, srcRect, dstRect, Paint());
  }

  // Dibuia una creu centrada a una casella del taulell
  void drawCross(Canvas canvas, double x0, double y0, double x1, double y1,
      Color color, double strokeWidth) {
    Paint paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth;

    canvas.drawLine(
      Offset(x0, y0),
      Offset(x1, y1),
      paint,
    );
    canvas.drawLine(
      Offset(x1, y0),
      Offset(x0, y1),
      paint,
    );
  }

  // Dibuixa el taulell
  void drawBoardStatus(Canvas canvas, Size size) {
    // Dibuixar 'X' i 'O' del tauler
    double cellWidth = size.width / int.parse(appData.taulell);
    double cellHeight = size.height / int.parse(appData.taulell);

    for (int i = 0; i < int.parse(appData.taulell); i++) {
      for (int j = 0; j < int.parse(appData.taulell); j++) {
        if (appData.board[i][j] == 'X') {
          double x0 = j * cellWidth;
          double y0 = i * cellHeight;
          double x1 = (j + 1) * cellWidth;
          double y1 = (i + 1) * cellHeight;

          drawImage(canvas, appData.imageMina!, x0, y0, x1, y1);
        }
        if (appData.flagMap[i][j].contains("F")) {
          //Busca la badera en flagMap
          // Dibuixar una bandera
          //Color color = Colors.blue;

          double x0 = j * cellWidth;
          double y0 = i * cellHeight;
          double x1 = (j + 1) * cellWidth;
          double y1 = (i + 1) * cellHeight;

          drawImage(canvas, appData.imageban!, x0, y0, x1, y1);
        } else if (appData.board[i][j].length == 2) {
          double x0 = j * cellWidth;
          double y0 = i * cellHeight;
          double x1 = (j + 1) * cellWidth;
          double y1 = (i + 1) * cellHeight;
          switch (appData.board[i][j]) {
            case "1+":
              {
                drawImage(canvas, appData.imageun!, x0, y0, x1, y1);
              }
              break;

            case "0+":
              {
                drawImage(canvas, appData.imagecer!, x0, y0, x1, y1);
              }
              break;
            case "2+":
              {
                drawImage(canvas, appData.imagedos!, x0, y0, x1, y1);
              }
              break;
            case "3+":
              {
                drawImage(canvas, appData.imagetres!, x0, y0, x1, y1);
              }
              break;
            case "4+":
              {
                drawImage(canvas, appData.imagequa!, x0, y0, x1, y1);
              }
              break;
            case "5+":
              {
                drawImage(canvas, appData.imagecin!, x0, y0, x1, y1);
              }
              break;
            case "6+":
              {
                drawImage(canvas, appData.imagesis!, x0, y0, x1, y1);
              }
              break;
            default:
              {
                //statements;
              }
              break;
          }
        }
      }
    }
  }

  // Dibuixa el missatge de joc acabat
  void drawGameOver(Canvas canvas, Size size) {
    String message = "El joc ha acabat. Has guanyat!";
    if (appData.gameWinner.compareTo('M') == 0) {
      message = "El joc ha acabat. Has perdut";
    }

    const textStyle = TextStyle(
      color: Colors.black,
      fontSize: 24.0,
      fontWeight: FontWeight.bold,
    );

    final textPainter = TextPainter(
      text: TextSpan(text: message, style: textStyle),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout(
      maxWidth: size.width,
    );

    // Centrem el text en el canvas
    final position = Offset(
      (size.width - textPainter.width) / 2,
      (size.height - textPainter.height) / 2,
    );

    // Dibuixar un rectangle semi-transparent que ocupi tot l'espai del canvas
    final bgRect = Rect.fromLTWH(0, 0, size.width, size.height);
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.7) // Ajusta l'opacitat com vulguis
      ..style = PaintingStyle.fill;

    canvas.drawRect(bgRect, paint);

    // Ara, dibuixar el text
    textPainter.paint(canvas, position);
  }

  // Funció principal de dibuix
  @override
  void paint(Canvas canvas, Size size) {
    drawBoardLines(canvas, size);
    drawBoardStatus(canvas, size);
    if (appData.gameWinner != '-') {
      //Final
      drawGameOver(canvas, size);
    }
  }

  // Funció que diu si cal redibuixar el widget
  // Normalment hauria de comprovar si realment cal, ara només diu 'si'
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
