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
    return Scaffold(
      appBar: AppBar(
        title: Text("Guante"),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text("Encender Bluetooth"),
              Switch(
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
          DropdownButton(
              items: _getDeviceItems(),
              value: _deviceList.isNotEmpty ? _device : null,
              onChanged: (value) {
                _device = value as BluetoothDevice;
                setState(() {});
              }),
          TextButton(
              onPressed: _isButtonUnavaible
                  ? null
                  : _connected
                      ? _disconnec
                      : _connect,
              child: Text(_connected ? 'Disconnect' : 'Connect')),
          TextButton(
              onPressed: _connected ? _sendOnMessageToBluetooth : null,
              child: Text("ON")),
          TextButton(
              onPressed: _connected ? _sendOffMessageToBluetooth : null,
              child: Text("Off"))
        ],
      ),
    );
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
