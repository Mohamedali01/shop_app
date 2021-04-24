import 'dart:async';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shop_app/exceptions/http_exception.dart';

class AuthProvider with ChangeNotifier {
  String _token;
  DateTime _expiredDate;
  String _userId;
  Timer _timer;

  String get userId {
    return _userId;
  }

  Future<void> _authHandling(String email, String password, String link) async {
    final String url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$link?key=AIzaSyBpw5d4ePtz7op48NHB-28wkowZIq3vVdM';
    try {
      http.Response response = await http.post(
        url,
        body: json.encode(
          {'email': email, 'password': password, 'returnSecureToken': true},
        ),
      );
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(message: responseData['error']['message']);
      }
      print(responseData);
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiredDate = DateTime.now().add(
        Duration(
          seconds: int.parse(
            responseData['expiresIn'],
          ),
        ),
      );
      notifyListeners();
      _autoLogout();
      final prefs = await SharedPreferences.getInstance();
      final encodedData = json.encode({
        'token': _token,
        'userId': _userId,
        'expiredDate': _expiredDate.toIso8601String()
      });
      prefs.setString('userData', encodedData);
    } catch (error) {
      throw error;
    }
  }

  bool get isAuth {
    return token != null;
  }

  String get token {
    if (_token == null ||
        _expiredDate.isBefore(DateTime.now()) ||
        _expiredDate == null) {
      return null;
    } else {
      return _token;
    }
  }

  Future<void> signUp(String email, String password) async {
    return _authHandling(email, password, 'signUp');
  }

  Future<void> signIn(String email, String password) async {
    return _authHandling(email, password, 'signInWithPassword');
  }

  Future<void> logout() async {
    _token = null;
    _expiredDate = null;
    _userId = null;
    notifyListeners();
    if (_timer != null) {
      _timer.cancel();
      _timer = null;
    }
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  Future<void> _autoLogout() async {
    if (_timer != null) {
      _timer.cancel();
      _timer = null;
    }
    final date = _expiredDate.difference(DateTime.now()).inSeconds;
    _timer = Timer(Duration(seconds: 30), logout);
  }

  Future<bool> autoLogin() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    final decodedData = json.decode(pref.getString('userData'));
    if (decodedData == null) {
      return false;
    }
    final expireData = DateTime.parse(decodedData['expiredDate']);
    if (expireData.isBefore(DateTime.now())) {
      return false;
    }
    _token = decodedData['token'];
    _userId = decodedData['userId'];
    _expiredDate = expireData;
    notifyListeners();
    return true;
  }
}
