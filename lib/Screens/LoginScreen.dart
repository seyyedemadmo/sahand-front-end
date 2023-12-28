import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../components/Buttoms.dart';
import "../components/Textfield.dart";
import "../api/api_client.dart";
import '../Screens/DashboardScreen.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  TextEditingController userController =   TextEditingController();
  TextEditingController passwordController =  TextEditingController();
  APIClient client = APIClient();


  @override
  void dispose() {
    // TODO: implement dispose
    userController.dispose();
    passwordController.dispose();
    super.dispose();
  }  

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder:(context) => Stack(children: [
        const BackgroundImage(),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Container(
                  height: 200,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                    image: AssetImage("lib/assist/logo.png"),
                  )),
                ),
              ),
              const SizedBox(
                  height: 70,
                  child: Center(
                      child: Text(
                    "Sahand",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 45,
                        fontWeight: FontWeight.bold),
                  )
                )
              ),
              const SizedBox(
                height: 50,
                child: Text(
                  'Intelligent data monitoring system',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(
                  width: 300, child: TextFieldYellowTransparent(" User name", userController)),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: 300,
                child: TextFieldPasswordYellowTransparent(" Password", passwordController),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: 300,
                height: 50,
                child: TextButton(
                  onPressed: () async {
                    EasyLoading.show(status: "Loging in ...", dismissOnTap: true);
                    try{
                      int res = await client.login(userController.text, passwordController.text);
                      if (res == 200){
                        // ShowSnakBar(context, "login successful", const Color.fromARGB(255, 56, 142, 60));
                        EasyLoading.showSuccess("Loging Successful");
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => DashboardPage(client),
                          )
                        );
                        }
                      else{
                          EasyLoading.showError("Loging Fail");
                        // ShowSnakBar(context, "login fail", Color.fromARGB(255, 253, 40, 40));
                      }
                    }
                    catch (e){
                      EasyLoading.showError("Something wrong "+ e.toString()); 
                    }
                    
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 255, 196, 0) ,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    )
                  ),
                  child: const Text(
                    "Login",
                    style: TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontSize: 25,
                    ),
                  ),
                )
              ),
              const SizedBox(
                height: 130,
              )
            ],
          ),
        )
      ])
    );
  }
}

void ShowSnakBar(BuildContext context, String message, Color color){
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(
            fontSize: 18
            ),
          ),
        backgroundColor: color,
      )
    );
}
class BackgroundImage extends StatelessWidget {
  const BackgroundImage({super.key});

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => const LinearGradient(
              colors: [Colors.black45, Colors.black12],
              begin: Alignment.bottomCenter,
              end: Alignment.center)
          .createShader(bounds),
      blendMode: BlendMode.darken,
      child: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('lib/assist/background.jpg'),
                fit: BoxFit.cover,
                colorFilter:
                    ColorFilter.mode(Colors.black45, BlendMode.darken))),
      ),
    );
  }
}
