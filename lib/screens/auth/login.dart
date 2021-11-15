import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lx_mobility/screens/auth/kakao_map_test.dart';
import 'package:lx_mobility/screens/native_kakao_map.dart';

import '../home.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _LoginState();
  }
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController textEditingControllerEmail;
  late TextEditingController textEditingControllerPass;

  @override
  void initState() {
    super.initState();
    textEditingControllerEmail = TextEditingController();
    textEditingControllerPass = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    var _size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
          child: Container(
              height: _size.height,
              margin: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.3),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          _createEmailField(),
                          _createPassField(),
                          _createLoginButton(),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerRight,
                    child: TextButton(onPressed: (){}, child: const Text('회원가입')),
                  )
                ],
              ))),
    );
  }

  Widget _createEmailField() {
    return TextFormField(
      controller: textEditingControllerEmail,
      onTap: () {},
      textAlign: TextAlign.left,
      decoration: const InputDecoration(
          labelText: '이메일 주소',
          prefixIcon: Icon(
            Icons.person_outline_outlined,
          )),
      style: const TextStyle(fontSize: 14, color: Colors.black),
    );
  }

  Widget _createPassField() {
    return TextFormField(
      controller: textEditingControllerPass,
      onTap: () {},
      textAlign: TextAlign.left,
      decoration: const InputDecoration(
          labelText: '비밀번호',
          prefixIcon: Icon(
            Icons.password_outlined,
          )),
      style: const TextStyle(fontSize: 14, color: Colors.black),
    );
  }

  Widget _createLoginButton() {
    var _size = MediaQuery.of(context).size;
    return Container(
      width: _size.width,
      height: 48,
      margin: const EdgeInsets.only(top: 16.0, bottom: 16.0),
      child: ElevatedButton(onPressed: () {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => NativeKakaoMap()));
      }, child: const Text('로그인')),
    );
  }
}
