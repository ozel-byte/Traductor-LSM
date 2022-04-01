import 'package:flutter/material.dart';

class PageSelec extends StatelessWidget {
  const PageSelec({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SingleChildScrollView(
                child: Text(
                  "Selecione una opcion a probar",
                  style: TextStyle(fontWeight: FontWeight.w300, fontSize: 25),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              TextButton(
                  style: ButtonStyle(
                      padding: MaterialStateProperty.all(
                          EdgeInsets.symmetric(horizontal: 80)),
                      backgroundColor: MaterialStateProperty.all(Colors.blue)),
                  onPressed: () {
                    Navigator.pushNamed(context, "lenguaje");
                  },
                  child: Text(
                    "Lenguaje senas",
                    style: TextStyle(color: Colors.white),
                  )),
              TextButton(
                  style: ButtonStyle(
                      padding: MaterialStateProperty.all(
                          EdgeInsets.symmetric(horizontal: 100)),
                      backgroundColor:
                          MaterialStateProperty.all(Colors.green[300])),
                  onPressed: () {
                    Navigator.pushNamed(context, "guante");
                  },
                  child: Text("Guante", style: TextStyle(color: Colors.white)))
            ],
          ),
        ],
      ),
    );
  }
}
