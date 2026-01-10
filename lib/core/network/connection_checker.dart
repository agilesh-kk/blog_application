import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

//interface for internet connection checking
abstract interface class ConnectionChecker {
  Future<bool> get isConnected;
}

//implementation of the interface created
class ConnectionCheckerImpl implements ConnectionChecker{
  final InternetConnection internetConnection;
  ConnectionCheckerImpl(this.internetConnection);

  @override
  //checks for the internet access
  Future<bool> get isConnected async => await internetConnection.hasInternetAccess;

}
