import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Widget> list_image = [];
  List<String> list_img = [
    "A",
    "B",
    "C",
    "D",
    "E",
    "F",
    "G",
    "H",
    "I",
    "J",
    "K",
    "L",
    "LL",
    "M",
    "N",
    "O",
    "P",
    "Q",
    "R",
    "S",
    "T",
    "U",
    "V",
    "W",
    "X",
    "Y",
    "Z"
  ];
  List<String> list_img_abe = [
    "A.jpeg",
    "B.jpeg",
    "C.jpeg",
    "D.jpeg",
    "E.jpeg",
    "F.jpeg",
    "G.jpeg",
    "H.jpeg",
    "I.jpeg",
    "J.jpeg",
    "K.jpeg",
    "L.jpeg",
    "LL.jpeg",
    "M.jpeg",
    "N.jpeg",
    "O.jpeg",
    "P.jpeg",
    "Q.jpeg",
    "R.jpeg",
    "S.jpeg",
    "T.jpeg",
    "U.jpeg",
    "V.jpeg",
    "W.jpeg",
    "X.jpeg",
    "Y.jpeg",
    "Z.jpeg"
  ];
  TextEditingController _controllertext = TextEditingController();
  int valid = 1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controllertext.addListener(() {
      print("l: " + _controllertext.text);
      if (_controllertext.text == " ") {
        print("espacio");
      }
      if (_controllertext.text == "") {
        print("entro aqui vacio el controller");
        list_image.clear();
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Lenguaje senas"),
        ),
        body: Column(
          children: [
            Container(
              width: size.width * 1,
              height: size.height * 0.1,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: TextField(
                  controller: _controllertext,
                  onChanged: (String v) {
                    print("letra: " + v);
                    list_image.clear();

                    if (v != " ") {
                      for (var i = 0; i < v.length; i++) {
                        print("primera vuelta: " + v.substring(i, i + 1));
                        if (v.substring(i, i + 1) != " ") {
                          if (v.substring(i, i + 1) == "á") {
                            final image =
                                Image(image: AssetImage("assets/A.jpeg"));
                            list_image.add(image);
                            setState(() {});
                          } else if (v.substring(i, i + 1) == "é") {
                            final image =
                                Image(image: AssetImage("assets/E.jpeg"));
                            list_image.add(image);
                            setState(() {});
                          } else if (v.substring(i, i + 1) == "Í") {
                            final image =
                                Image(image: AssetImage("assets/I.jpeg"));
                            list_image.add(image);
                            setState(() {});
                          } else if (v.substring(i, i + 1) == "ó") {
                            final image =
                                Image(image: AssetImage("assets/O.jpeg"));
                            list_image.add(image);
                            list_image.add(image);
                            setState(() {});
                          } else if (v.substring(i, i + 1) == "ú") {
                            final image =
                                Image(image: AssetImage("assets/U.jpeg"));
                            list_image.add(image);
                            setState(() {});
                          } else {
                            final image = Image(
                                image: AssetImage("assets/" +
                                    v.substring(i, i + 1).toUpperCase() +
                                    ".jpeg"));
                            list_image.add(image);
                            setState(() {});
                          }
                        } else {
                          list_image.add(Container(
                            width: 30,
                            height: 10,
                          ));
                          setState(() {});
                        }
                      }
                    } else {
                      list_image.add(Container(
                        width: 30,
                        height: 10,
                      ));
                      setState(() {});
                    }
                    // if (valid == 1) {
                    //   list_image.add(Image(
                    //       image: AssetImage("assets/" +
                    //           v
                    //               .substring(v.length - 1, v.length)
                    //               .toUpperCase() +
                    //           ".jpeg")));
                    //   setState(() {});
                    // } else {
                    //   print("Segunda imagen");
                    //   list_image.add(Image(
                    //       image: AssetImage("assets/" +
                    //           v
                    //               .substring(v.length - 1, v.length)
                    //               .toUpperCase() +
                    //           ".jpeg")));
                    //   setState(() {});
                    // }
                    // valid = 0;
                  },
                  decoration: InputDecoration(hintText: 'ingrese el texto'),
                ),
              ),
            ),
            Container(
                width: size.width * 1,
                height: size.height * 0.4,
                color: Color(0xffe6ccef),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: getImage(),
                      ),
                    ],
                  ),
                ))
          ],
        ));
  }

  void verificarImg() {}
  List<Widget> getImage() {
    return list_image;
  }
}
