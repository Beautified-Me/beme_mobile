import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';

class ConnectionStatusSingleton {
  // This creates the singles instance by calling the _internal constructore specificed below 
  static final ConnectionStatusSingleton _singleton = new ConnectionStatusSingleton._internal();
  ConnectionStatusSingleton._internal();

  //This is what's used to retrive the instance through the app 
  static ConnectionStatusSingleton getInstance() => _singleton;

  //This tracks the current connection status 
  bool hasConnection = false;

  //This is how we'll allow subcribing to connection changes 
  StreamController connectionChangeController = new StreamController.broadcast();

  //Flutter connectivity 
  final Connectivity _connectivity = Connectivity();

  //Hool into flutter_connectivity stream to listen for changes and check the connection status out of the gate 
  void initialize() {
    _connectivity.onConnectivityChanged.listen(_connectionChange);
    checkConnection();
  }

  Stream get connectionChange => connectionChangeController.stream;

  // A clean up method close our StreamController because this is meant to exist throught the entire application life cycle this really an issue 
  void dispose(){ 
    connectionChangeController.close();
  }

  // flutter_connectivity listener
  void _connectionChange(ConnectivityResult result) {
    checkConnection();
  }

//see if its connection happening 
 Future<bool> checkConnection() async {
        bool previousConnection = hasConnection;
        try {
            final result = await InternetAddress.lookup('google.com');
            if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
                hasConnection = true;
            } else {
                hasConnection = false;
            }
        } on SocketException catch(_) {
            hasConnection = false;
        }

        //The connection status changed send out an update to all listeners
        if (previousConnection != hasConnection) {
            connectionChangeController.add(hasConnection);
        }

        return hasConnection;
    }


}