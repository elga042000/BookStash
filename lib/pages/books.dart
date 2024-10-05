import 'package:books_stashh/services/database.dart';
import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';
import 'package:fluttertoast/fluttertoast.dart';
class Books extends StatefulWidget {
  const Books({super.key});

  @override
  State<Books> createState() => _BooksState();
}

class _BooksState extends State<Books> {
  TextEditingController titleController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController authorController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Books'),
        foregroundColor: Colors.white,
        backgroundColor: const Color.fromARGB(255, 5, 42, 41),
      ),
      body: SingleChildScrollView(
        child: Padding( 
          padding: const EdgeInsets.all(10.0),
          child: Container(margin: EdgeInsets.only(top: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Title',
                  style: TextStyle(color: Colors.black, fontSize: 20,fontStyle: FontStyle.italic),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
        
                  //margin: const EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
                  child: TextFormField(
                    controller: titleController,
                    decoration: InputDecoration(border: OutlineInputBorder(),),
                  ),
                ),
        
        
                const Text(
                  'Price',
                  style: TextStyle(color: Colors.black, fontSize: 20,fontStyle: FontStyle.italic),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
        
                  //decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
                  //margin: const EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
                  child: TextFormField(
                    controller: priceController,
                    decoration: InputDecoration(border: OutlineInputBorder(),),
                  ),
                ),
                const Text(
                  'Author',
                  style: TextStyle(color: Colors.black, fontSize: 20,fontStyle: FontStyle.italic),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  //decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
                  //margin: const EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
                  child: TextFormField(
                    controller: authorController,
                    decoration: InputDecoration(border: OutlineInputBorder(),),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Center(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 4, 59, 71)),
                    onPressed: () async {
                      String id=randomAlphaNumeric(10);
                      Map<String,dynamic>bookInfoMap={
                        "Title":titleController.text,
                        "Price":priceController.text,
                        "Author":authorController.text,
                        "Id":id,
                      };
                      await DataBaseHelper().addBookDetails(bookInfoMap,id).then((value) {
        
                        Fluttertoast.showToast(
                            msg: "Book has been added!",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.green,
                            textColor: Colors.white,
                            fontSize: 16.0
                        );
                      }
                      );
                    },
                    child: const Text('Add',style: TextStyle(color: Colors.white),),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
