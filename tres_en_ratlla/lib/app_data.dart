import 'dart:async';
import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class AppData with ChangeNotifier {
  // App status
  String taulell = "9";
  String mines = "5";
  List<List<String>> board = [];

  bool gameIsOver = false;
  String gameWinner = '-';
  int minas = 5;
  int width = 9;
  int cnt = 0;
  ui.Image? imagePlayer;
  ui.Image? imageOpponent;
  ui.Image? imageun;
  ui.Image? imagecer;
  ui.Image? imagedos;
  ui.Image? imagetres;
  ui.Image? imagequa;
  ui.Image? imagecin;
  ui.Image? imagesis;
  ui.Image? imageban;
  bool imagesReady = false;

  void resetGame(int minas, int width) {
    board = [];
    cnt = 0;

    for (int x = 0; x < width; x++) {
      List<String> row = [];
      for (int y = 0; y < width; y++) {
        row.add('-');
      }
      board.add(row);
    }

    for (int cnt = 0; cnt < minas; cnt++) {
      int columna = Random().nextInt(width) as int;
      int row = Random().nextInt(width) as int;
      board[row][columna] = "M";
    }

    gameIsOver = false;
    gameWinner = '-';

    for (int x = 0; x < width; x++) {
      for (int y = 0; y < width; y++) {
        if (board[x][y].compareTo("M") != 0) {
          exploreAndMark(x, y);
        }
      }
    }
  }

  // Fa una jugada, primer el jugador després la maquina
  void playMove(int row, int col) {
    if (board[row][col] == 'M') {
      board[row][col] = 'X';
      checkGameWinner(); //Cambiar mensanje
    } else if (board[row][col] == '1') {
      board[row][col] = '1+';
      cnt++;
    } else if (board[row][col] == '0') {
      board[row][col] = '0+';
      cnt++;
    } else if (board[row][col] == '2') {
      board[row][col] = '2+';
      cnt++;
    } else if (board[row][col] == '3') {
      board[row][col] = '3+';
      cnt++;
    } else if (board[row][col] == '4') {
      board[row][col] = '4+';
      cnt++;
    } else if (board[row][col] == '5') {
      board[row][col] = '5+';
      cnt++;
    } else if (board[row][col] == '6') {
      board[row][col] = '6+';
      cnt++;
    }

    if (cnt == (width * width) - minas) {
      checkGameWinner();
    }
  }

  void flagCreation(row, col) {
    if (board[row][col] == 'M') {
      board[row][col] = 'F';
    }
    if (board[row][col] == 'F') {
      board[row][col] = 'M';
    }
  }

  // Comprova si el joc ja té un tres en ratlla
  // No comprova la situació d'empat
  void checkGameWinner() {
    for (int i = 0; i < 9; i++) {
      // Comprovar files
      if (board[i][0] == board[i][1] &&
          board[i][1] == board[i][2] &&
          board[i][0] != '-') {
        gameIsOver = true;
        gameWinner = board[i][0];
        return;
      }

      // Comprovar columnes
      if (board[0][i] == board[1][i] &&
          board[1][i] == board[2][i] &&
          board[0][i] != '-') {
        gameIsOver = true;
        gameWinner = board[0][i];
        return;
      }
    }

    // Comprovar diagonal principal
    if (board[0][0] == board[1][1] &&
        board[1][1] == board[2][2] &&
        board[0][0] != '-') {
      gameIsOver = true;
      gameWinner = board[0][0];
      return;
    }

    // Comprovar diagonal secundària
    if (board[0][2] == board[1][1] &&
        board[1][1] == board[2][0] &&
        board[0][2] != '-') {
      gameIsOver = true;
      gameWinner = board[0][2];
      return;
    }

    // No hi ha guanyador, torna '-'
    gameWinner = '-';
  }

  // Carrega les imatges per dibuixar-les al Canvas
  Future<void> loadImages(BuildContext context) async {
    // Si ja estàn carregades, no cal fer res
    if (imagesReady) {
      notifyListeners();
      return;
    }

    // Força simular un loading
    await Future.delayed(const Duration(milliseconds: 500));

    Image tmpPlayer = Image.asset('assets/images/Mina.png'); // Imagen Mina
    Image tmpOpponent = Image.asset('assets/images/opponent.png');
    Image bandera = Image.asset('assets/images/bandera.png');
    Image cero = Image.asset('assets/images/0.png');
    Image un = Image.asset('assets/images/1.png');
    Image dos = Image.asset('assets/images/2.png');
    Image tres = Image.asset('assets/images/3.png');
    Image quatre = Image.asset('assets/images/4.png');
    Image cinc = Image.asset('assets/images/5.png');
    Image sis = Image.asset('assets/images/6.png');

    // Carrega les imatges
    if (context.mounted) {
      imagePlayer = await convertWidgetToUiImage(tmpPlayer);
    }
    if (context.mounted) {
      imageOpponent = await convertWidgetToUiImage(tmpOpponent);
    }
    if (context.mounted) {
      imageun = await convertWidgetToUiImage(un);
    }
    if (context.mounted) {
      imagecer = await convertWidgetToUiImage(cero);
    }
    if (context.mounted) {
      imagedos = await convertWidgetToUiImage(dos);
    }
    if (context.mounted) {
      imagetres = await convertWidgetToUiImage(tres);
    }
    if (context.mounted) {
      imagequa = await convertWidgetToUiImage(quatre);
    }
    if (context.mounted) {
      imagecin = await convertWidgetToUiImage(cinc);
    }
    if (context.mounted) {
      imagesis = await convertWidgetToUiImage(sis);
    }
    if (context.mounted) {
      imageban = await convertWidgetToUiImage(bandera);
    }

    imagesReady = true;

    // Notifica als escoltadors que les imatges estan carregades
    notifyListeners();
  }

  // Converteix les imatges al format vàlid pel Canvas
  Future<ui.Image> convertWidgetToUiImage(Image image) async {
    final completer = Completer<ui.Image>();
    image.image.resolve(const ImageConfiguration()).addListener(
          ImageStreamListener(
            (info, _) => completer.complete(info.image),
          ),
        );
    return completer.future;
  }

  void exploreAndMark(int row, int col) {
    // Verificar si estamos dentro de los límites del tablero
    if (row < 0 || row >= width || col < 0 || col >= width) {
      return;
    }

    // Verificar si ya hemos explorado esta casilla o si es una mina
    if (board[row][col] != '-') {
      return;
    }

    // Contar minas adyacentes
    int minesAround = 0;

    for (int dr = -1; dr <= 1; dr++) {
      for (int dc = -1; dc <= 1; dc++) {
        int newRow = row + dr;
        int newCol = col + dc;

        if (newRow >= 0 && newRow < width && newCol >= 0 && newCol < width) {
          if (board[newRow][newCol] == 'M') {
            minesAround++;
          }
        }
      }
    }

    // Marcar la casilla con el número de minas adyacentes
    board[row][col] = minesAround.toString();

    // Si no hay minas adyacentes, explorar las casillas adyacentes
    if (minesAround == 0) {
      for (int dr = -1; dr <= 1; dr++) {
        for (int dc = -1; dc <= 1; dc++) {
          int newRow = row + dr;
          int newCol = col + dc;
          exploreAndMark(newRow, newCol);
        }
      }
    }
  }
}
