import 'package:books_stashh/pages/books.dart';
import 'package:books_stashh/services/auth_service.dart';
import 'package:books_stashh/services/database.dart';
import 'package:books_stashh/utils/toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController titleController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController authorController = TextEditingController();
  Stream? bookStream;

  dynamic getInfoInit() async {
    bookStream = await DataBaseHelper().getAllBooksInfo();
    setState(() {

    });
  }

  @override
  void initState() {
    getInfoInit();
    super.initState();
  }

  Widget allBookInfo() {
    return StreamBuilder(builder: (context, AsyncSnapshot snapshot) {
      return snapshot.hasData ? ListView.builder(
        itemCount: snapshot.data.docs.length,
        itemBuilder: (context, index) {
          DocumentSnapshot documentSnapshot = snapshot.data.docs[index];
          return Container(margin: EdgeInsets.all(10),
            child: Material(
              elevation: 5.0,
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: EdgeInsets.all(20),
                width: MediaQuery
                    .of(context)
                    .size
                    .width,

                decoration: BoxDecoration(color: Color.fromARGB(255, 153,255,153),
                  borderRadius: BorderRadius.circular(20),
                ),

                child: Column(crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(
                          Icons.book_outlined, size: 30, color: Colors.brown,),




                        InkWell(child: Icon(Icons.edit_document, size: 30,
                          color: Colors.indigoAccent,),
                          onTap: () {
                            titleController.text = documentSnapshot["Title"];
                            priceController.text = documentSnapshot["Price"];
                            authorController.text = documentSnapshot["Author"];
                            editBook(documentSnapshot.id, context);
                          },
                        ),

                        InkWell(
                          child: Icon(
                            Icons.delete_forever, size: 30, color: Colors.redAccent,),
                          onTap: (){
                            showDeleteConfirmationDialog(context,documentSnapshot.id);
                          },

                        ),

                     ],
                    ),
                    SizedBox(height: 10,),
                    Text(
                      'Title:${documentSnapshot["Title"]}',
                      style: TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.bold,
                        fontSize: 23,
                      ),),

                    Text(
                      'Author:${documentSnapshot["Author"]}',
                      style: TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.bold,
                          fontSize: 20
                      ),),
                    Text(
                      'Price:${documentSnapshot["Price"]}',
                      style: TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.bold,
                          fontSize: 18
                      ),),
                  ],
                ),
              ),

            ),
          );
        },
      )
          : Container();
    },
      stream: bookStream,
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Stash'),
        actions: [IconButton(onPressed: () async{
          await AuthServiceHelper.logout();
          Navigator.pushReplacementNamed(context, '/login');

        }, icon: Icon(Icons.logout_rounded))],
        foregroundColor: Colors.white,
        backgroundColor: const Color.fromARGB(255, 5, 42, 41),
      ),
      body: Container(
        margin: EdgeInsets.only(top: 10, left: 10, right: 10),

        child: Column(crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Expanded(child: allBookInfo(),),


          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const Books(),
              ));
        },

        backgroundColor: const Color.fromARGB(255, 5, 42, 41),
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }


//editBook function

  Future editBook(String id, BuildContext context) {
    return showDialog(context: context, builder: (context) =>
        AlertDialog(
          content: SingleChildScrollView(
            child: Column(
              children: [
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Edit a book", style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 30
                      ,),),
            
                    InkWell(
                      child: Icon(
                        Icons.cancel_outlined, size: 35, color: Colors.red,),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
                Divider(height: 10, color: Colors.blueGrey, thickness: 5,),
                SizedBox(height: 20,),
                const Text(
                  'Title',
                  style: TextStyle(color: Colors.black, fontSize: 20),
                ),
                Container(
                  padding: const EdgeInsets.only(left: 12.0),
            
                  margin: const EdgeInsets.only(
                      left: 20.0, right: 20.0, top: 20.0),
                  child: TextField(
                    controller: titleController,
                    //decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
                  ),
                ),
                SizedBox(height: 20,),
                const Text(
                  'Price',
                  style: TextStyle(color: Colors.black, fontSize: 20),
                ),
                Container(
                  padding: const EdgeInsets.only(left: 12.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20)),
                  margin: const EdgeInsets.only(
                      left: 20.0, right: 20.0, top: 20.0),
                  child: TextField(
                    controller: priceController,
                  ),
                ),
                SizedBox(height: 20,),
                const Text(
                  'Author',
                  style: TextStyle(color: Colors.black, fontSize: 20),
                ),
                Container(
                  padding: const EdgeInsets.only(left: 12.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20)),
                  margin: const EdgeInsets.only(
                      left: 20.0, right: 20.0, top: 20.0),
                  child: TextField(
                    controller: authorController,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
            
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                  OutlinedButton(
                      style: OutlinedButton.styleFrom(backgroundColor: Color.fromARGB(255, 4, 59, 71)),
                      onPressed: ()async{
                   Map<String,dynamic>updateDetails={
                     "Title":titleController.text,
                     "Price":priceController.text,
                     "Author":authorController.text,
                     "Id":id,
                   } ;
            
                   await DataBaseHelper().updateBook(id,updateDetails).then((value){
                     Message.show(message: "Updated Succesfully!!");
            
                   });
                   Navigator.pop(context);
                  },
                   child: Text("Update", style: TextStyle(color: Colors.white))),
            
                ],)
              ],
            ),
          ),
        ));
  }

  void showDeleteConfirmationDialog(BuildContext context,String id){
    showDialog(context: context, builder: (context)
    {
      return AlertDialog(
      title: Text('Confirm Deletion'),
    content: Text('Are you sure you want to delete?'),
    actions: [
      TextButton(onPressed: () async{
        await DataBaseHelper().deleteBook(id);
        Navigator.pop(context);

    },
    child: Text("Yes"),
    ),
    TextButton(onPressed: () {

    Navigator.pop(context);

    },
    child: Text("No"),
    ),

    ],
      );

    });
  }
}