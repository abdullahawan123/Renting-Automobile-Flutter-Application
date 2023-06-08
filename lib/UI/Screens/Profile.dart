import 'package:flutter/material.dart';
import 'package:wheel_for_a_while/UI/Widgets/hexStringToColor.dart';

class Profile extends StatefulWidget {
  final String username;
  final String email;
  const Profile({Key? key, required this.username, required this.email}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      title: const Text("Notification"),
      centerTitle: true,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              hexStringToColor("03DAC6"),
              hexStringToColor("03DAC6"),
              hexStringToColor("1C201D"),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
      ),
    ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          width: double.infinity,
          child: Column(
            children: [
              const SizedBox(height: 20,),
              const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.person,
                  size: 50,
                ),
              ),
              const SizedBox(height: 10,),
              Text(
                widget.username,
                style: const TextStyle(
                    fontSize:25,fontWeight: FontWeight.bold
                ),),
              Text(
                widget.email,
                style: const TextStyle(
                    fontSize:18,
                    fontWeight: FontWeight.normal
                ),),
              const SizedBox(height: 10,),
              const Divider(height: 3,thickness: 3,),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    ListTile(
                      leading: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: const Color.fromARGB(26, 211, 210, 210)
                        ),
                        child: const Icon(Icons.settings,color: Colors.greenAccent,),
                      ),
                      title: const Text("Settings",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                      trailing: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: const Color.fromARGB(26, 211, 210, 210)
                        ),
                        child: const Icon(Icons.arrow_forward_ios,color: Colors.greenAccent,),
                      ),
                      onTap: (){

                      },
                    ),
                    ListTile(
                      leading: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: const Color.fromARGB(26, 211, 210, 210)
                        ),
                        child: const Icon(Icons.person_2,color: Colors.greenAccent,),
                      ),
                      title: const Text("About Seller",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                      trailing: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: const Color.fromARGB(26, 211, 210, 210)
                        ),
                        child: const Icon(Icons.arrow_forward_ios,color: Colors.greenAccent,),
                      ),
                      onTap: (){

                      },
                    ),
                    ListTile(
                        leading: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: const Color.fromARGB(26, 211, 210, 210)
                          ),
                          child: const Icon(Icons.payment,color: Colors.greenAccent,),
                        ),
                        title: const Text("Payment",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                        trailing: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: const Color.fromARGB(26, 211, 210, 210)
                          ),
                          child: const Icon(Icons.arrow_forward_ios,color: Colors.greenAccent,),
                        ),
                        onTap: (){

                        }
                    ),
                    ListTile(
                      leading: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: const Color.fromARGB(26, 211, 210, 210)
                        ),
                        child: const Icon(Icons.delivery_dining,color: Colors.greenAccent,),
                      ),
                      title: const Text("Delivery",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                      trailing: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: const Color.fromARGB(26, 211, 210, 210)
                        ),
                        child: const Icon(Icons.arrow_forward_ios,color: Colors.greenAccent,),
                      ),
                      onTap: (){

                      },
                    ),
                    ListTile(
                      leading: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: const Color.fromARGB(26, 211, 210, 210)
                        ),
                        child: const Icon(Icons.policy,color: Colors.greenAccent,),
                      ),
                      title: const Text("Privacy Policy",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                      trailing: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: const Color.fromARGB(26, 211, 210, 210)
                        ),
                        child: const Icon(Icons.arrow_forward_ios,color: Colors.greenAccent,),
                      ),
                      onTap: (){

                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
