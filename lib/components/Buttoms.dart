import "package:flutter/material.dart";
import "../api/api_client.dart";

class LoginButtom extends StatelessWidget {
  const LoginButtom({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: (){
        APIClient client = APIClient();
        
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
    );
  }
}