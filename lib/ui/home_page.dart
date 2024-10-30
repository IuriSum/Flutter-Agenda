import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_agenda/helpers/contact_helper.dart';


class _HomePageState extends State<HomePage> {

  late ContactHelper helper;
  // late ContactHelper contactHelper2; the second helper has the same instance as the first
  // because of the singleton attribute


  Future<void> _saveTestUser()async{
    Contact contact = Contact("Test", "test@email.com");

    helper.saveContact(contact);
  }

  @override
  void initState() {
    super.initState();

    _saveTestUser();

    helper.getAllContacts().then((list){
      print(list);
    });
  }

  @override
  Widget build(BuildContext context){
    double height = MediaQuery.of(context).size.height,
     width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.black.withOpacity(0.2),
          statusBarIconBrightness: Brightness.light,
        ),
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        width: width,
        height: height,
        padding: EdgeInsets.fromLTRB(20, 40, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
          ]
        )
      ),
    );
  }
}

class HomePage extends StatefulWidget{
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}