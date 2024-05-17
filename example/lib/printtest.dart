import 'dart:io';

import 'package:flutter/services.dart';
import 'package:idata_label_printer/idata_label_printer.dart';
import 'package:idata_label_printer_example/enum.dart';
import 'package:path_provider/path_provider.dart';

class PrintTest {
  IdataLabelPrinter bluetooth = IdataLabelPrinter.instance;

  slip() async {
    // image from file path
    String fileName = 'samplelogo.png';
    ByteData bytesData = await rootBundle.load("assets/images/$fileName");
    String dir = (await getApplicationDocumentsDirectory()).path;
    File file = await File('$dir/$fileName').writeAsBytes(bytesData.buffer
        .asUint8List(bytesData.offsetInBytes, bytesData.lengthInBytes));

    ///image from Asset
    ByteData bytesAsset = await rootBundle.load("assets/images/$fileName");
    Uint8List imageBytes = bytesAsset.buffer
        .asUint8List(bytesAsset.offsetInBytes, bytesAsset.lengthInBytes);

    bluetooth.isConnected.then((isConnected) => {
          if (isConnected == true)
            {
              bluetooth.printNewLine(),
              bluetooth.printText(
                  "Print Test", PrintSize.medium.val, PrintAlign.left.val),
              bluetooth.printImage(file.path),
              bluetooth.printImageBytes(imageBytes),
              bluetooth.printNewLine(),
              bluetooth.printQRcode(
                  "Insert Custom Text", 80, 80, PrintAlign.left.val),
              bluetooth.printBarCode(
                  "Insert Custom Text", 40, 40, PrintAlign.left.val),
              bluetooth.printNewLine(),
              bluetooth.paperCut(),
            }
        });
  }
}
