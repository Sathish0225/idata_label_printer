import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'idata_label_printer_method_channel.dart';

abstract class IdataLabelPrinterPlatform extends PlatformInterface {
  /// Constructs a IdataLabelPrinterPlatform.
  IdataLabelPrinterPlatform() : super(token: _token);

  static final Object _token = Object();

  static IdataLabelPrinterPlatform _instance = MethodChannelIdataLabelPrinter();

  /// The default instance of [IdataLabelPrinterPlatform] to use.
  ///
  /// Defaults to [MethodChannelIdataLabelPrinter].
  static IdataLabelPrinterPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [IdataLabelPrinterPlatform] when
  /// they register themselves.
  static set instance(IdataLabelPrinterPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
