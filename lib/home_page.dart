import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:personel/datas.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key,}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
      String? userName;
      int? userLevel;
    TextEditingController detail = TextEditingController();
    TextEditingController title = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();




  Future<void> formValidation() async {
    User? currentUser;
    final FirebaseAuth authUser =FirebaseAuth.instance;
    currentUser = authUser.currentUser;
    if (currentUser != null && userName!.isNotEmpty) {
      FirebaseFirestore.instance.collection("talepler").doc(currentUser.uid).
      set({
        "userUid": currentUser.uid,
        "detail": detail.text.toString(),
        "title":title.text.toString(),
        "userName": userName,
        "createDate": DateTime.now()
      }).whenComplete(() {
        title.clear();
        detail.clear();
        showDialog(context: context, builder: (context) {
          return const AlertDialog(
            content: Text('Talebiniz başarıyla kaydedildi.'),
          );

        });
      });
    }
  }


  Future getData() async {
    User? user = FirebaseAuth.instance.currentUser;
    var snap =await FirebaseFirestore.instance.collection('users').doc(user!.uid).get();
   setState(() {
    userName= snap['userName'];
    userLevel= snap['userLevel'];
   });
  }

  @override
  void initState() {
    super.initState();
    getData();
  }



  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=>FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Personel İstek Kutusu', style: TextStyle(color: Colors.white),),
          backgroundColor: Colors.orange,
          actions: [
            IconButton(onPressed: (){
              if(userLevel == 1){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>const Datas()));
              }else{
                showDialog(context: context, builder: (context) {
                  return const AlertDialog(
                    content: Text('Bu kısmı görüntülemeye yetikiniz yok.'),
                  );

                });
              }
            },
                icon:const Icon(
                  Icons.list,
                  color: Colors.white,
                ))
          ],
          automaticallyImplyLeading: false,
          centerTitle: true,
        ),
        body: GestureDetector(
          onTap: ()=>FocusManager.instance.primaryFocus?.unfocus(),
          child: SingleChildScrollView(
            child:  Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Text('Merhaba $userName, lütfen bizimle görüş/istek ve önerilerini paylaşır mısın?'),
                    const SizedBox(height: 10,),
                    TextFormField(
                      controller: title,
                      obscureText: false,
                      decoration: InputDecoration(
                          border:  const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.teal)
                          ),
                          prefixIcon: const Icon(Icons.title, color: Colors.cyan, ),
                          focusColor: Theme.of(context).primaryColor,
                          hintText: 'Başlık'
                      ),
                    ),
                    const SizedBox(height: 10,),
                    TextFormField(
                      controller: detail,
                      maxLines: 10,
                      obscureText: false,
                      decoration: InputDecoration(
                        border:  const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.teal)
                        ),
                        prefixIcon: const Icon(Icons.description, color: Colors.cyan, ),
                        focusColor: Theme.of(context).primaryColor,
                        hintText: 'Detay Giriniz',
                      ),
                    ),
                    const SizedBox(height: 10,),
                    ElevatedButton(onPressed: (){
                      formValidation();
                    },
                        child: const Text('Gönder')),
                    const SizedBox(height: 25,),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
