// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:idata_label_printer/idata_label_printer.dart';
import 'package:idata_label_printer_example/printtest.dart';

void main() {
  runApp(const MyAppWrapper());
}

class MyAppWrapper extends StatelessWidget {
  const MyAppWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyApp(),
    );
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  IdataLabelPrinter bluetooth = IdataLabelPrinter.instance;

  List<BluetoothDevice> devices = [];
  BluetoothDevice? device;
  bool connected = false;

  String tips = "";
  PrintTest printTest = PrintTest();
  final GlobalKey<State> keyLoader = GlobalKey<State>();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  void setStateIfMounted(f) {
    if (mounted) setState(f);
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    bool? isConnected = await bluetooth.isConnected;
    List<BluetoothDevice> devicesList = [];
    try {
      devicesList = await bluetooth.getBluetoothDevices();
    } on PlatformException catch (e) {
      Future.delayed(Duration.zero, () {
        showAlertDialog(context, "Error!", e.message.toString());
      });
    }

    bluetooth.onStateChanged().listen((state) {
      switch (state) {
        case (IdataLabelPrinter.STATE_CONNECTED || IdataLabelPrinter.CONNECTED):
          setStateIfMounted(() {
            connected = true;
            tips = "Bluetooth Device State: Connected";
          });
          break;
        case IdataLabelPrinter.STATE_DISCONNECTED:
          setStateIfMounted(() {
            connected = false;
            tips = "Bluetooth Device State: Disconnected";
          });
          break;
        case IdataLabelPrinter.STATE_TURNING_OFF:
          setStateIfMounted(() {
            connected = false;
            tips = "Bluetooth Device State: Bluetooth turning off";
          });
          break;
        case IdataLabelPrinter.STATE_OFF:
          setStateIfMounted(() {
            connected = false;
            tips = "Bluetooth Device State: Bluetooth off";
          });
          break;
        case IdataLabelPrinter.STATE_ON:
          setStateIfMounted(() {
            connected = false;
            tips = "Bluetooth Device State: Bluetooth on";
          });
          break;
        case IdataLabelPrinter.STATE_TURNING_ON:
          setStateIfMounted(() {
            connected = false;
            tips = "Bluetooth Device State: Bluetooth turning on";
          });
          break;
        case IdataLabelPrinter.ERROR:
          setStateIfMounted(() {
            connected = false;
            tips = "Bluetooth Device State: error";
          });
          break;
        default:
          setStateIfMounted(() {
            connected = false;
            tips = "Bluetooth Device State: $state";
          });
          break;
      }
    });

    if (!mounted) return;

    setState(() {
      devices = devicesList;
    });

    if (isConnected == true) {
      setState(() {
        connected = true;
      });
    }
  }

  Future<void> connect(BluetoothDevice device) async {
    try {
      Dialogs.showLoadingDialog(context, keyLoader);
      if (!connected) {
        await bluetooth.connect(device).then((_) =>
            Navigator.of(keyLoader.currentContext!, rootNavigator: true).pop());
      }
    } on PlatformException catch (e) {
      Navigator.of(keyLoader.currentContext!, rootNavigator: true).pop();
      showAlertDialog(context, "Error!", e.message.toString());
    }
  }

  Future<void> disconnect() async {
    try {
      Dialogs.showLoadingDialog(context, keyLoader);
      await bluetooth.disconnect();
      Navigator.of(keyLoader.currentContext!, rootNavigator: true).pop();
    } on PlatformException catch (e) {
      Navigator.of(keyLoader.currentContext!, rootNavigator: true).pop();
      showAlertDialog(context, "Error!", e.message.toString());
    }
  }

  void showAlertDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          backgroundColor: Colors.white,
          title: Text(
            title.toUpperCase(),
            style: const TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.w700,
            ),
          ),
          content: Text(message, style: const TextStyle(fontSize: 14.0)),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                  backgroundColor: Colors.grey,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0))),
              child: const Text(
                'Okay',
                style: TextStyle(fontSize: 14.0, color: Colors.white),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('iData Label Printer'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            tips,
                            style: const TextStyle(fontSize: 14.0),
                          ),
                        ),
                      ],
                    ),
                    const Divider(),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.63,
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: devices.length,
                        itemBuilder: (context, index) {
                          return listTile(devices[index]);
                        },
                      ),
                    ),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        OutlinedButton(
                          onPressed: connected ? () => printTest.slip() : () {},
                          style: OutlinedButton.styleFrom(
                            foregroundColor:
                                connected ? Colors.green : Colors.black12,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            side: BorderSide(
                              width: 1.0,
                              color: connected ? Colors.green : Colors.black12,
                            ),
                          ),
                          child: const Text("Print Test"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  listTile(BluetoothDevice d) {
    return ListTile(
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.print_rounded, color: Colors.black, size: 20.0),
          const SizedBox(width: 4.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                d.name ?? '',
                style: const TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              Text(
                d.address ?? '',
                style: const TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF999999),
                ),
              ),
            ],
          ),
        ],
      ),
      onTap: () async {
        setState(() {
          device = d;
        });
      },
      trailing: OutlinedButton(
        onPressed: connected
            ? disconnect
            : () {
                connect(d);
              },
        style: OutlinedButton.styleFrom(
          foregroundColor: connected ? Colors.red : Colors.green,
          padding: const EdgeInsets.all(6.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          side: BorderSide(
            width: 1.0,
            color: connected ? Colors.red : Colors.green,
          ),
        ),
        child: Text(
          connected ? "Disconnect" : "Connect",
        ),
      ),
    );
  }
}

class Dialogs {
  static Future<void> showLoadingDialog(
      BuildContext context, GlobalKey key) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return PopScope(
          canPop: false,
          child: SimpleDialog(
            key: key,
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            children: const <Widget>[
              Center(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      color: Colors.grey,
                      strokeWidth: 4.0,
                    ),
                    SizedBox(width: 8.0),
                    Text(
                      "Please Wait ...",
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
