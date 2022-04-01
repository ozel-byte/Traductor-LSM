import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class PageBlue extends StatefulWidget {
  const PageBlue({Key? key}) : super(key: key);

  @override
  State<PageBlue> createState() => _PageBlueState();
}

class _PageBlueState extends State<PageBlue> {
  BluetoothState _bluetoothState = BluetoothState.UNKNOWN;

  FlutterBluetoothSerial _bluetoothSerial = FlutterBluetoothSerial.instance;
  List<BluetoothDevice> _deviceList = [];

  var connection;

  bool get isConnected => connection != null && connection.isConnected;

  var _deviceState;
  var _device;
  bool _isButtonUnavaible = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    FlutterBluetoothSerial.instance.state.then((state) {
      setState(() {
        _bluetoothState = state;
      });
    });

    _deviceState = 0;

    enabledBluetooth();

    FlutterBluetoothSerial.instance
        .onStateChanged()
        .listen((BluetoothState state) {
      setState(() {
        _bluetoothState = state;

        getPairedDevices();
      });
    });
  }

  Future<bool> enabledBluetooth() async {
    _bluetoothState = await FlutterBluetoothSerial.instance.state;

    if (_bluetoothState == BluetoothState.STATE_OFF) {
      await FlutterBluetoothSerial.instance.requestEnable();
      await getPairedDevices();
      return true;
    } else {
      await getPairedDevices();
    }
    return false;
  }

  Future<void> getPairedDevices() async {
    List<BluetoothDevice> devices = [];

    try {
      devices = await _bluetoothSerial.getBondedDevices();
    } on PlatformException {
      print("Error");
    }

    if (!mounted) {
      return;
    }

    setState(() {
      _deviceList = devices;
    });
  }

  bool isDisconnecting = false;

  @override
  void dispose() {
    // TODO: implement dispose
    if (isConnected) {
      isDisconnecting = true;
      connection.dispose();
      connection = null!;
    }
    super.dispose();
  }

  bool _connected = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          elevation: 0.0,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back,
                color: Colors.black,
              )),
          title: Text(
            "Encender bluetooth",
            style: TextStyle(color: Colors.black),
          ),
          actions: [
            Switch(
                activeColor: Colors.blue,
                value: _bluetoothState.isEnabled,
                onChanged: (bool value) {
                  future() async {
                    if (value) {
                      await FlutterBluetoothSerial.instance.requestEnable();
                    } else {
                      await FlutterBluetoothSerial.instance.requestDisable();
                    }

                    await getPairedDevices();
                    _isButtonUnavaible = false;

                    if (_connected) {
                      _disconnec();
                    }
                  }

                  future().then((_) => {setState(() {})});
                }),
          ],
        ),
        body: Column(
          children: [
            Container(
                width: size.width * 1,
                height: size.height * 0.08,
                child: Row(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Lista de dispositivos",
                            style: TextStyle(
                                fontWeight: FontWeight.w300, fontSize: 30),
                          ),
                        ),
                      ],
                    ),
                  ],
                )),
            Divider(),
            Container(
              width: size.width * 1,
              height: size.height * 0.4,
              child: listDeviceActive(),
            ),
            Divider(),
            Container(
              width: size.width * 1,
              height: size.height * 0.35,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Mandar señal",
                          style: TextStyle(
                              fontWeight: FontWeight.w300, fontSize: 30)),
                      SizedBox(
                        width: 10,
                      ),
                      Icon(Icons.account_tree_outlined)
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextButton(
                          style: ButtonStyle(
                              padding: MaterialStateProperty.all(
                                  EdgeInsets.symmetric(horizontal: 50)),
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.blue[200])),
                          onPressed: () {},
                          child: Text(
                            "On",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )),
                      TextButton(
                          style: ButtonStyle(
                              padding: MaterialStateProperty.all(
                                  EdgeInsets.symmetric(horizontal: 50)),
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.red[200])),
                          onPressed: () {},
                          child: Text(
                            "Off",
                            style: TextStyle(
                                color: Colors.red, fontWeight: FontWeight.bold),
                          ))
                    ],
                  )
                ],
              ),
            )
          ],
        ));
  }

  List<DropdownMenuItem<BluetoothDevice>> _getDeviceItems() {
    List<DropdownMenuItem<BluetoothDevice>> items = [];
    if (_deviceList.isEmpty) {
      items.add(DropdownMenuItem(child: Text('NONE')));
    } else {
      _deviceList.forEach((element) {
        items.add(DropdownMenuItem(
          child: Text(element.name!),
          value: element,
        ));
      });
    }
    return items;
  }

  void _connect() async {
    if (_device == null) {
      print("dispositivo no select");
    } else {
      if (!isConnected) {
        await BluetoothConnection.toAddress(_device.address)
            .then((_connection) {
          print("Connected to the device");
          connection = _connection;

          setState(() {
            _connected = true;
          });

          connection.input!.listen(null).onDone(() {
            if (isDisconnecting) {
              print("Disconnecting locally!");
            } else {
              print("Disconnecyed remotely!");
            }

            if (this.mounted) {
              setState(() {});
            }
          });
        });
      }
    }
  }

  Widget listDeviceActive() {
    if (_deviceList.isEmpty) {
      return Center(
        child: Text("None"),
      );
    } else {
      return ListView.builder(
        itemCount: _deviceList.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_deviceList[index].name!),
            subtitle: Text(_deviceList[index].address),
            trailing: TextButton(onPressed: () {}, child: Text("Connect")),
          );
        },
      );
    }
  }

  void _disconnec() async {
    await connection.close();

    if (!connection.isConnected) {
      setState(() {
        _connected = false;
      });
    }
  }

  void _sendOnMessageToBluetooth() async {
    connection.output.add(Utf8Encoder().convert('1'));
    await connection.output.allSent;
    setState(() {
      _deviceState = 1;
    });
  }

  void _sendOffMessageToBluetooth() async {
    connection.output.add(Utf8Encoder().convert('0'));
    await connection.output.allSent;
    setState(() {
      _deviceState = -1;
    });
  }
}
// DropdownButton(
//                   items: _getDeviceItems(),
//                   value: _deviceList.isNotEmpty ? _device : null,
//                   onChanged: (value) {
//                     _device = value as BluetoothDevice;
//                     setState(() {});
//                   }),
//               TextButton(
//                   onPressed: _isButtonUnavaible
//                       ? null
//                       : _connected
//                           ? _disconnec
//                           : _connect,
//                   child: Text(_connected ? 'Disconnect' : 'Connect')),
//               TextButton(
//                   style: ButtonStyle(
//                       padding: MaterialStateProperty.all(
//                           EdgeInsets.symmetric(horizontal: 100)),
//                       backgroundColor:
//                           MaterialStateProperty.all(Colors.blue[300])),
//                   onPressed: _connected ? _sendOnMessageToBluetooth : null,
//                   child: Text("ON")),
//               TextButton(
//                   style: ButtonStyle(
//                       padding: MaterialStateProperty.all(
//                           EdgeInsets.symmetric(horizontal: 100)),
//                       backgroundColor:
//                           MaterialStateProperty.all(Colors.red[300])),
//                   onPressed: _connected ? _sendOffMessageToBluetooth : null,
//                   child: Text("Off"))