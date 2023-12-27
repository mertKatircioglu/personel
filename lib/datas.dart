import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Datas extends StatefulWidget {
  const Datas({Key? key}) : super(key: key);

  @override
  State<Datas> createState() => _DatasState();
}

class _DatasState extends State<Datas> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('İstek/Şikayet ve Öneriler Listesi', style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.orange,
        automaticallyImplyLeading: true,
        centerTitle: true,
      ),
      body:StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection(
              'talepler')
              .snapshots(),
          builder: (ctx, recentSnapshot) {
            if (recentSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CupertinoActivityIndicator(),
              );
            }else if(recentSnapshot.data!.docs.isEmpty){
              return Padding(
                padding: EdgeInsets.only(top:MediaQuery.of(context).size.height/3  ),
                child:  const Center(
                  child: Text('Kayıt Bulunamadı',),
                ),
              );
            }
            final recentDocs = recentSnapshot.data!.docs;
            return FutureBuilder(
              builder: (context, futureSnapshot) {
                return ListView.builder(
                    itemCount: recentDocs.length,
                    itemBuilder: (context, index) {
                      // print(recentDocs[index]['uploadedImages'].toString());
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          child: Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [

                                  Text(
                                    'Başlık: ${recentDocs[index]['title']}',
                                    style: const TextStyle(fontSize: 16,
                                        color: Colors.orange,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  const SizedBox(height: 3,),
                                  Text(
                                    '${recentDocs[index]['detail']}',
                                  ),
                                  const SizedBox(height: 10,),

                                  Text(
                                    'Ad-Soyad: ${recentDocs[index]['userName']}',
                                    style: const TextStyle(fontSize: 12,
                                        fontWeight: FontWeight.w600),
                                  ),


                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    });
              },
              future: null,
            );
          }),
    );
  }
}
