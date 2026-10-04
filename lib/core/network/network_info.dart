import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkInfo {
  bool _ok(List<ConnectivityResult> r) => !r.contains(ConnectivityResult.none);

  Future<bool> get isConnected async =>
      _ok(await Connectivity().checkConnectivity());

  Stream<bool> get onChange async* {
    yield await isConnected;
    yield* Connectivity().onConnectivityChanged.map(_ok);
  }
}
