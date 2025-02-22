import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityProvider with ChangeNotifier {
  bool _isConnected = true;
  bool get isConnected => _isConnected;

  late StreamSubscription<List<ConnectivityResult>> _subscription;

  ConnectivityProvider() {
    _checkInitialConnection();
    _subscription = Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> result) {
      bool hasConnection = result.isNotEmpty && !result.contains(ConnectivityResult.none);
      if (_isConnected != hasConnection) {
        _isConnected = hasConnection;
        notifyListeners();
      }
      log(hasConnection ? "Connected: $result" : "No Internet Connection");
    });
  }

  Future<void> _checkInitialConnection() async {
    List<ConnectivityResult> result = await Connectivity().checkConnectivity();
    _isConnected = result.isNotEmpty && !result.contains(ConnectivityResult.none);
    notifyListeners();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
