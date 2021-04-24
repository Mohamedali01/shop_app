import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../exceptions/http_exception.dart';
import '../provider/auth_provider.dart';

enum AuthMode { SignUp, Login }

class AuthScreen extends StatelessWidget {
  static final String id = '/auth-screen';

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(215, 117, 255, 1).withOpacity(0.5),
                  Color.fromRGBO(255, 188, 117, 1).withOpacity(0.9),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0, 1],
              ),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              height: deviceSize.height,
              width: deviceSize.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    child: Container(
                      margin: EdgeInsets.only(bottom: 20.0),
                      padding: EdgeInsets.symmetric(
                        horizontal: 94.0,
                        vertical: 8.0,
                      ),
                      transform: Matrix4.rotationZ(-8 * pi / 180)
                        ..leftTranslate(-10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.deepOrange.shade900,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        'MyShop',
                        style: TextStyle(
                            color: Theme.of(context)
                                .accentTextTheme
                                .headline6
                                .color,
                            fontSize: 50,
                            fontWeight: FontWeight.normal,
                            fontFamily: 'Anton'),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: deviceSize.width > 600 ? 2 : 1,
                    child: AuthCard(),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  AuthMode _authMode = AuthMode.Login;
  Map<String, String> _authData = {'email': '', 'password': ''};

  var _isLoading = false;
  final _passwordController = TextEditingController();

  AnimationController _animationController;
  Animation _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _animation = Tween<Size>(
      begin: Size(double.infinity, 260),
      end: Size(double.infinity, 320),
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.linear),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Error occurred!'),
        content: Text(message),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Okay'))
        ],
      ),
    );
  }

  Future<void> _submit() async {
    print('_submit: executed');
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    try {
      if (_authMode == AuthMode.Login) {
        print('AuthMode: SignIn');
        await Provider.of<AuthProvider>(context, listen: false)
            .signIn(_authData['email'], _authData['password']);
      } else {
        print('AuthMode: SignUp');
        await Provider.of<AuthProvider>(context, listen: false)
            .signUp(_authData['email'], _authData['password']);
      }
    } on HttpException catch (error) {
      var message = 'Authentication failed';
      if (error.message.contains('EMAIL_EXISTS')) {
        message = 'This email is already exist';
      } else if (error.message.contains('TOO_MANY_ATTEMPTS_TRY_LATER')) {
        message = 'too many attempts please try later';
      } else if (error.message.contains('EMAIL_NOT_FOUND')) {
        message = 'This email isn\'t found';
      } else if (error.message.contains('INVALID_PASSWORD')) {
        message = 'This password is invalid';
      }
      _showErrorDialog(message);
    } catch (error) {
      var message = 'Error happened please try again later';
      _showErrorDialog(message);
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.SignUp;
        _animationController.forward();
      });
    } else {
      setState(() {
        _authMode = AuthMode.Login;
        _animationController.reverse();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // var size = _animation.value as Size;
    final deviceSize = MediaQuery.of(context).size;
    return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 8.0,
        child: AnimatedContainer(
          curve: Curves.slowMiddle,
          //_animation.value.height
          height: _authMode == AuthMode.SignUp ? 320 : 260,
          constraints: BoxConstraints(minHeight: _animation.value.height),
          width: deviceSize.width * 0.75,
          padding: EdgeInsets.all(16),
          duration: Duration(milliseconds: 300),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(labelText: 'E-mail'),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value.isEmpty || !value.contains('@')) {
                        return 'Invalid email';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _authData['email'] = value;
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Password'),
                    obscureText: true,
                    controller: _passwordController,
                    validator: (value) {
                      if (value.isEmpty || value.length < 5) {
                        return 'Password is too short';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _authData['password'] = value;
                    },
                  ),
                  if (_authMode == AuthMode.SignUp)
                    TextFormField(
                      enabled: _authMode == AuthMode.SignUp,
                      decoration:
                          InputDecoration(labelText: 'Confirm Password'),
                      obscureText: true,
                      validator: _authMode == AuthMode.SignUp
                          ? (value) {
                              if (value.isEmpty) {
                                return 'Enter confirm password';
                              }
                              if (value != _passwordController.text) {
                                return 'Passwords don\'t match';
                              }
                              return null;
                            }
                          : null,
                    ),
                  SizedBox(
                    height: 20,
                  ),
                  if (_isLoading)
                    CircularProgressIndicator()
                  else
                    RaisedButton(
                      child: Text(
                          _authMode == AuthMode.Login ? 'Login' : 'Sign Up'),
                      onPressed: _submit,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 8),
                      color: Theme.of(context).primaryColor,
                      textColor:
                          Theme.of(context).primaryTextTheme.button.color,
                    ),
                  FlatButton(
                    onPressed: _switchAuthMode,
                    child: Text(
                      '${_authMode == AuthMode.Login ? 'SIGNUP' : 'LOGIN'} INSTEAD',
                    ),
                    padding:
                        EdgeInsets.symmetric(horizontal: 30.0, vertical: 4.0),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    textColor: Theme.of(context).primaryColor,
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
