import 'package:flutter_test/flutter_test.dart';
import 'package:idata_label_printer/idata_label_printer.dart';
import 'package:idata_label_printer/idata_label_printer_platform_interface.dart';
import 'package:idata_label_printer/idata_label_printer_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockIdataLabelPrinterPlatform
    with MockPlatformInterfaceMixin
    implements IdataLabelPrinterPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final IdataLabelPrinterPlatform initialPlatform =
      IdataLabelPrinterPlatform.instance;

  test('$MethodChannelIdataLabelPrinter is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelIdataLabelPrinter>());
  });

  test('getPlatformVersion', () async {
    IdataLabelPrinter idataLabelPrinterPlugin = IdataLabelPrinter.instance;
    MockIdataLabelPrinterPlatform fakePlatform =
        MockIdataLabelPrinterPlatform();
    IdataLabelPrinterPlatform.instance = fakePlatform;

    expect(await idataLabelPrinterPlugin.getPlatformVersion(), '42');
  });
}
