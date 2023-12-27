import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:personel/home_page.dart';
class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();




  Future<void> formValidation() async{
    User? currentUser;
    final FirebaseAuth authUser =FirebaseAuth.instance;
    if(passwordController.text == confirmPasswordController.text){
        if(confirmPasswordController.text.isNotEmpty && emailController.text.isNotEmpty &&
            nameController.text.isNotEmpty){
          await authUser.createUserWithEmailAndPassword(email: emailController.text.trim(),
              password: passwordController.text.trim()).then((auth) => {
            currentUser= auth.user,
          if(currentUser != null){
              FirebaseFirestore.instance.collection("users").doc(currentUser!.uid).
          set({
            "uid": currentUser!.uid,
            "userName": nameController.text.trim(),
                "userLevel":0,
            "userEmail": emailController.text.toString(),
            "createDate": DateTime.now()
          }).whenComplete(() => {
            Navigator.pop(context),
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (c)=>const HomePage()))
          })
        }
          }).catchError((error){
            Navigator.pop(context);
            showDialog(context: context, builder: (context){
              return const AlertDialog(
                content: Text('Bir Hata Oluştu. Lütfen Tekrar Deneyin.'),
              );
            });
          });
        }else{
          showDialog(context: context, builder: (context){
            return const AlertDialog(
              content: Text('Lütfen Tüm Alanları Doldurun.'),
            );
          });
        }
      } else{
      showDialog(context: context, builder: (context){
        return const AlertDialog(
          content: Text('Parola ve Tekrar Parolası birbiri ile eşleşmiyor.'),
        );
      });
      }

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text('Kayıt Formu',style: TextStyle(color: Colors.white),),
      ),
    body: Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: nameController,
                  obscureText: false,
                  decoration: InputDecoration(
                      border:  const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.teal)
                      ),
                      prefixIcon: const Icon(Icons.person, color: Colors.cyan, ),
                      focusColor: Theme.of(context).primaryColor,
                      hintText: 'Adınız - Soyadınız'
                  ),
                ),
                const SizedBox(height: 10,),
                TextFormField(
                  controller: emailController,
                  obscureText: false,
                  decoration: InputDecoration(
                      border:  const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.teal)
                      ),
                      prefixIcon: const Icon(Icons.email, color: Colors.cyan, ),
                      focusColor: Theme.of(context).primaryColor,
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
                      focusColor: Theme.of(context).primaryColor,
                      hintText: 'Şifre'
                  ),
                ),
                const SizedBox(height: 10,),
                TextFormField(
                  controller: confirmPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                      border:  const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.teal)
                      ),
                      prefixIcon: const Icon(Icons.password, color: Colors.cyan, ),
                      focusColor: Theme.of(context).primaryColor,
                      hintText: 'Şifre Tekrar'
                  ),
                ),
                const SizedBox(height: 20,),
                ElevatedButton(onPressed: (){
                  formValidation();
                },
                    child: const Text('Kayıt Ol')),
                const SizedBox(height: 25,),
              ],
            ),
          ),
        )
      ],
    ),
    );
  }
}
