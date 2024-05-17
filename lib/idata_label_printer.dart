// ignore_for_file: constant_identifier_names

import 'dart:async';

import 'package:flutter/services.dart';
import 'idata_label_printer_platform_interface.dart';

class IdataLabelPrinter {
  static const int ERROR = -1;
  static const int STATE_CONNECTED = 1;
  static const int CONNECTED = 2;
  static const int STATE_DISCONNECTED = 0;
  static const int STATE_OFF = 10;
  static const int STATE_TURNING_ON = 11;
  static const int STATE_ON = 12;
  static const int STATE_TURNING_OFF = 13;

  static const String namespace = 'idata_label_printer';

  static const MethodChannel _channel = MethodChannel('$namespace/methods');

  static const EventChannel _readChannel = EventChannel('$namespace/read');

  static const EventChannel _stateChannel = EventChannel('$namespace/state');

  final StreamController<MethodCall> _methodStreamController =
      StreamController.broadcast();

  IdataLabelPrinter._() {
    _channel.setMethodCallHandler((MethodCall call) async {
      _methodStreamController.add(call);
    });
  }

  static final IdataLabelPrinter _instance = IdataLabelPrinter._();

  static IdataLabelPrinter get instance => _instance;

  //onStateChanged()
  Stream<int?> onStateChanged() async* {
    yield await _channel.invokeMethod('state').then((buffer) => buffer);

    yield* _stateChannel.receiveBroadcastStream().map((buffer) => buffer);
  }

  Future<String?> getPlatformVersion() {
    return IdataLabelPrinterPlatform.instance.getPlatformVersion();
  }

  // //onRead()
  Stream<String> onRead() =>
      _readChannel.receiveBroadcastStream().map((buffer) => buffer.toString());

  Future<bool?> get isAvailable async =>
      await _channel.invokeMethod('isAvailable');

  Future<bool?> get isOn async => await _channel.invokeMethod('isOn');

  Future<bool?> get isConnected async =>
      await _channel.invokeMethod('isConnected');

  Future<bool?> get openSettings async =>
      await _channel.invokeMethod('openSettings');

  //getBluetoothDevices()
  Future<List<BluetoothDevice>> getBluetoothDevices() async {
    final List list = await (_channel.invokeMethod('getBluetoothDevices'));
    return list.map((map) => BluetoothDevice.fromMap(map)).toList();
  }

  //isDeviceConnected(BluetoothDevice device)
  Future<bool?> isDeviceConnected(BluetoothDevice device) =>
      _channel.invokeMethod('isDeviceConnected', device.toMap());

  //connect(BluetoothDevice device)
  Future<dynamic> connect(BluetoothDevice device) =>
      _channel.invokeMethod('connect', device.toMap());

  //disconnect()
  Future<dynamic> disconnect() => _channel.invokeMethod('disconnect');

  //pageSetup(int pageWidth, int pageHeight)
  Future<dynamic> pageSetup(int pageWidth, int pageHeight) =>
      _channel.invokeMethod('pageSetup', {
        'pageWidth': pageWidth,
        'pageHeight': pageHeight,
      });

  //write(String message)
  Future<dynamic> write(String message) =>
      _channel.invokeMethod('write', {'message': message});

  //writeBytes(Uint8List message)
  Future<dynamic> writeBytes(Uint8List message) =>
      _channel.invokeMethod('writeBytes', {'message': message});

  //printCustom(String message, int size, int align,{String? charset})
  Future<dynamic> printText(String message, int size, int align,
          {String? charset}) =>
      _channel.invokeMethod('printText', {
        'message': message,
        'size': size,
        'align': align,
        'charset': charset
      });

  //printImage(String pathImage)
  Future<dynamic> printImage(String pathImage) =>
      _channel.invokeMethod('printImage', {'pathImage': pathImage});

  //printImageBytes(Uint8List bytes)
  Future<dynamic> printImageBytes(Uint8List bytes) =>
      _channel.invokeMethod('printImageBytes', {'bytes': bytes});

  //printNewLine()
  Future<dynamic> printNewLine() => _channel.invokeMethod('printNewLine');

  //paperCut()
  Future<dynamic> paperCut() => _channel.invokeMethod('paperCut');

  //printQRcode(String textToQR, int width, int height, int align)
  Future<dynamic> printQRcode(
          String textToQR, int width, int height, int align) =>
      _channel.invokeMethod('printQRcode', {
        'textToQR': textToQR,
        'width': width,
        'height': height,
        'align': align
      });

  //printBarCode(String printBarCode, int width, int height, int align)
  Future<dynamic> printBarCode(
          String textToBarCode, int width, int height, int align) =>
      _channel.invokeMethod('printBarCode', {
        'textToBarCode': textToBarCode,
        'width': width,
        'height': height,
        'align': align
      });

  //drawerPin5()
  Future<dynamic> drawerPin2() => _channel.invokeMethod('drawerPin2');

  //drawerPin5()
  Future<dynamic> drawerPin5() => _channel.invokeMethod('drawerPin5');

  //printLeftRight(String string1, String string2, int size,{String? charset, String? format})
  Future<dynamic> printLeftRight(String string1, String string2, int size,
          {String? charset, String? format}) =>
      _channel.invokeMethod('printLeftRight', {
        'string1': string1,
        'string2': string2,
        'size': size,
        'charset': charset,
        'format': format
      });

  //print3Column(String string1, String string2, String string3, int size,{String? charset, String? format})
  Future<dynamic> print3Column(
          String string1, String string2, String string3, int size,
          {String? charset, String? format}) =>
      _channel.invokeMethod('print3Column', {
        'string1': string1,
        'string2': string2,
        'string3': string3,
        'size': size,
        'charset': charset,
        'format': format
      });

  //print4Column(String string1, String string2, String string3,String string4, int size,{String? charset, String? format})
  Future<dynamic> print4Column(String string1, String string2, String string3,
          String string4, int size,
          {String? charset, String? format}) =>
      _channel.invokeMethod('print4Column', {
        'string1': string1,
        'string2': string2,
        'string3': string3,
        'string4': string4,
        'size': size,
        'charset': charset,
        'format': format
      });

  //printLine(int lineWidth,int start_x,int start_y, int end_x,int end_y)
  Future<dynamic> printLine(
          int lineWidth, int startX, int startY, int endX, int endY) =>
      _channel.invokeMethod('printLine', {
        'lineWidth': lineWidth,
        'start_x': startX,
        'start_y': startY,
        'end_x': endX,
        'end_y': endY
      });
}

class BluetoothDevice {
  final String? name;
  final String? address;
  final int type = 0;
  bool connected = false;

  BluetoothDevice(this.name, this.address);

  BluetoothDevice.fromMap(Map map)
      : name = map['name'],
        address = map['address'];

  Map<String, dynamic> toMap() => {
        'name': name,
        'address': address,
        'type': type,
        'connected': connected,
      };

  @override
  operator ==(Object other) {
    return other is BluetoothDevice && other.address == address;
  }

  @override
  int get hashCode => address.hashCode;
}
