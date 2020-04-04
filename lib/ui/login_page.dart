import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:list_movie/controllers/auth_provider.dart';
import 'package:list_movie/ui/dummy_home.dart';
import 'package:list_movie/utils/logo.dart';

class LogiPage extends StatefulWidget {
  @override
  _LogiPageState createState() => _LogiPageState();
}

class _LogiPageState extends State<LogiPage> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool _loading = false;
  bool _wrongPassword = false;
  String _error;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    Color color = Colors.black54;
    Color fillColor = Color(0xFFF7F7F7);
    Color borderShadow = Color(0xFFD5D5D5);
    if(Theme.of(context).brightness == Brightness.dark){
      fillColor = Color(0xFF1F1B24);
      borderShadow = Colors.black38;
      color = Colors.white54;
    }

    final decoration = BoxDecoration(
        borderRadius: BorderRadius.circular(80),
        color: fillColor,
        boxShadow: [BoxShadow(color: borderShadow, blurRadius: 5.0)]);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            _loading ? LinearProgressIndicator() : Container(),
            SizedBox(
              height: 60,
            ),
            Logo(
              size: width * 0.45,
            ),
            SizedBox(
              height: 60,
            ),
            //show error
            _error == null || _error.isEmpty?
                Container():
            Container(
              padding: EdgeInsets.only(left: 10,right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.error,color: Colors.redAccent,size: 14,),
                  SizedBox(width: 12,),
                  Expanded(child: Text(_error,style: TextStyle(color: Colors.redAccent),)),
                ],
              ),
            ),
            //email field
            Container(
              padding: const EdgeInsets.fromLTRB(15, 8, 8, 8),
              margin: const EdgeInsets.all(10),
              child: TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                    hintText: "Email Address",
                    hintStyle: TextStyle(color: color),
                    icon: Icon(
                      Icons.email,
                      color: color,
                    ),
                    border: InputBorder.none),
              ),
              decoration: decoration,
            ),
            SizedBox(
              height: 15,
            ),
            //password field
            Container(
                padding: const EdgeInsets.fromLTRB(15, 8, 8, 8),
                margin: const EdgeInsets.all(10),
                child: TextField(
                  controller: _passwordController,
                  keyboardType: TextInputType.emailAddress,
                  obscureText: true,
                  decoration: InputDecoration(
                      hintText: "Password",
                      hintStyle: TextStyle(color: color),
                      icon: Icon(
                        Icons.lock,
                        color: color,
                      ),
                      border: InputBorder.none),
                ),
                decoration: decoration),
            SizedBox(
              height: 40,
            ),
            //Raised button
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: InkWell(
                radius: 80,
                onTap: () => _signUp(),
                child: Container(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Login",
                          style: Theme.of(context)
                              .textTheme
                              .headline6
                              .copyWith(color: Colors.white),
                        ),
                        SizedBox(width: 15,),
                        _loading?SpinKitRing(
                          color: Colors.white,
                          size: 20,
                          lineWidth: 2,
                        ): Container()
                      ],
                    ),
                  ),
                  decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
                        Colors.teal,
                        Colors.green,
                        Colors.lightGreen
                      ]),
                      borderRadius: BorderRadius.circular(80),
                      boxShadow: [
                        BoxShadow(
                          color: borderShadow,
                          offset: Offset(0.0, 1.5),
                          blurRadius: 1.5,
                        ),
                      ]),
                ),
              ),
            ),
            _wrongPassword? Container(
              margin: EdgeInsets.only(top: 25),
              child: InkWell(
                onTap: ()=>_resetPassword(),
                  child: Text("Forgot Password?",style: TextStyle(fontWeight: FontWeight.bold),)),
            ):Container(),
          ],
        ),
      ),
    );
  }

  ///This method used for sign up
  void _signUp() async{
    final email = _emailController.text;
    final password = _passwordController.text;
    if(email.isEmpty || password.isEmpty){
      setState(() {
        _error = "Email or Password cannot be empty";
      });
      return;
    }
    if(!_loading){
      setState(() {
        _loading = true;
        _error = null;
        _wrongPassword = false;
      });

      try{
        AuthProvider _auth = AuthProvider();
        await _auth.loginWithEmail(email, password);
        //TODO :add home
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context)=>DummyHome()
        ));
      }catch(error){
        String errorMessage;
        print("+++++++++++++");
        print(error.message);
        switch (error.code) {
          case "ERROR_INVALID_EMAIL":
            errorMessage = "Your email address appears to be malformed.";
            break;
          case "ERROR_WEAK_PASSWORD":
            errorMessage = "Password should be at least 6 characters";
            break;
          case "ERROR_WRONG_PASSWORD":
            errorMessage = "The password is invalid";
            setState(() {
              _wrongPassword = true;
            });
            break;
          case "ERROR_USER_NOT_FOUND":
            errorMessage = "User with this email doesn't exist.";
            break;
          case "ERROR_USER_DISABLED":
            errorMessage = "User with this email has been disabled.";
            break;
          case "ERROR_TOO_MANY_REQUESTS":
            errorMessage = "We have blocked all requests from this device due to unusual activity. Try again later.";
            break;
          case "ERROR_OPERATION_NOT_ALLOWED":
            errorMessage = "Signing in with Email and Password is not enabled.";
            break;
          default:
            errorMessage = "An undefined Error happened.";
        }
        setState(() {
          _error = errorMessage;

        });
      }finally{
        setState(() {
          _loading = false;
        });
    }

    }
  }

  void _resetPassword()async {
    final email = _emailController.text;
    AuthProvider authProvider = AuthProvider();
    await authProvider.resetPassword(email);

    await showDialog(context: context,builder: (context)=>AlertDialog(
      title: Text("Email Sent",textAlign: TextAlign.center,),
      content: Text("We have sent a password reset email to $email"),
      actions: <Widget>[
        MaterialButton(
          onPressed: (){
            Navigator.pop(context);
          },
          child: Text("Okay!",style: TextStyle(color: Colors.pinkAccent),),
        )
      ],
    ));
    setState(() {
      _wrongPassword = false;
    });
  }
}
