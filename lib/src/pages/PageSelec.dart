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
              TextButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.blue)),
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, "lenguaje");
                  },
                  child: Text(
                    "Lenguaje senas",
                    style: TextStyle(color: Colors.white),
                  )),
              TextButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.red[200])),
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, "guante");
                  },
                  child: Text("Guante", style: TextStyle(color: Colors.white)))
            ],
          ),
        ],
      ),
    );
  }
}
