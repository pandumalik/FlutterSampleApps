import 'package:flutter/material.dart';


class Login extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => new _State();
}

class _State extends State<Login> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  _login(){
    if(nameController.text == 'admin' && passwordController == 'admin'){
      // Navigator.push(context, route)
    }else{
      
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Login Screen App'),
        ),
        body: Padding(
            padding: EdgeInsets.all(10),
            child: ListView(
              children: <Widget>[
                Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(10),
                    child: Text(
                      'LOGIN TEST',
                      style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.w500,
                          fontSize: 30),
                    )),
                Container(
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'User Name',
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: TextField(
                    obscureText: true,
                    controller: passwordController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                    ),
                  ),
                ),
                Spacer(),
                Container(
                    height: 50,
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: RaisedButton(
                      textColor: Colors.white,
                      color: Colors.blue,
                      child: Text('Login'),
                      onPressed: () {
                        _login();
                        print(nameController.text);
                        print(passwordController.text);
                      },
                    )),
                // Container(
                //     child: Row(
                //       children: <Widget>[
                //         Text('Does not have account?'),
                //         FlatButton(
                //           textColor: Colors.blue,
                //           child: Text(
                //             'LOGIN',
                //             style: TextStyle(fontSize: 20),
                //           ),
                //           onPressed: () {
                //             //signup screen
                //           },
                //         )
                //       ],
                //       mainAxisAlignment: MainAxisAlignment.center,
                //     ))
              ],
            )));
  }
}