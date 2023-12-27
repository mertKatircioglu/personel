import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:personel/home_page.dart';

import 'sign_up.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void authUserAndLogin() async{
    if(emailController.text.isNotEmpty && passwordController.text.isNotEmpty){
      User? currentUser;
      final authUser = FirebaseAuth.instance;
      try{
        await authUser.signInWithEmailAndPassword(email: emailController.text.trim(),
            password: passwordController.text.trim()).then((auth) => {
          currentUser= auth.user,
        });
        if(currentUser != null){
          if (context.mounted) Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>const HomePage()));
          await Future.delayed(const Duration(seconds: 1));
        }
      } catch(e){
       showDialog(context: context, builder: (context){
         return const AlertDialog(
           content: Text('Kullanıcı Adı veya Parola Hatalı'),
         );
       });
      }
    }

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 100,),
          const Text('Lütfen Kullanıcı Bilgilerinizi Giriniz'),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                        border: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.teal)
                        ),
                        prefixIcon: const Icon(Icons.email, color: Colors.cyan, ),
                        focusColor: Theme.of(context).primaryColorDark,
                        hintText: 'E-posta Adresiniz'
                    ),
                  ),
                  const SizedBox(height: 10,),
                  TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                        border:  const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.teal)
                        ),
                        prefixIcon: const Icon(Icons.password, color: Colors.cyan, ),
                        focusColor: Theme.of(context).primaryColorDark,
                        hintText: 'Şifreniz'
                    ),
                  ),
                  const SizedBox(height: 20,),

                  ElevatedButton(onPressed: (){
                   authUserAndLogin();
                 },
                     child: const Text('Giriş Yap')),
                  const SizedBox(height: 10,),
                  ElevatedButton(onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>const SignUpPage()));
                  },
                      child: const Text('Üye Ol')),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
