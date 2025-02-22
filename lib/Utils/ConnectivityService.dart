import 'dart:async';
import 'dart:developer';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  StreamSubscription<List<ConnectivityResult>>? subscription;

  void startListening() {
    subscription = Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> result) {
      if (result.isEmpty || result.contains(ConnectivityResult.none)) {
        log("No Internet Connection");
      } else {
        log("Connected: $result");
      }
    });
  }

  void stopListening() {
    subscription?.cancel();
  }
}
