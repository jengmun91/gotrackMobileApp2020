import 'package:flutter/material.dart';
import 'package:gotrack_flutter/models/tnInputFormatter.dart';
import 'package:gotrack_flutter/providers/trackingNumberInputProvider.dart';
import 'package:provider/provider.dart';

class TrackingNumberInput extends StatefulWidget {
  const TrackingNumberInput({Key key}) : super(key: key);

  @override
  _TrackingNumberInputState createState() => _TrackingNumberInputState();
}

class _TrackingNumberInputState extends State<TrackingNumberInput> {
  TextEditingController _newTnController;
  UniqueKey uniqKey = UniqueKey();

  @override
  void initState() {
    super.initState();
    _newTnController = TextEditingController(
        text: Provider.of<TrackingNumberInputProvider>(context, listen: false)
            .text);
  }

  @override
  void dispose() {
    _newTnController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tnInputNumberProv = Provider.of<TrackingNumberInputProvider>(context);
    return TextField(
      controller: _newTnController,
      autofocus: false,
      onChanged: (text) {
        tnInputNumberProv.setText(text);
      },
      inputFormatters: [
        TnInputFormatter(),
      ],
      style: TextStyle(fontSize: 20),
      decoration: InputDecoration(
        filled: true,
        hintText: 'Enter tracking number',
        hintStyle: TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.normal,
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 1, horizontal: 10),
        suffixIcon: IconButton(
          iconSize: 20,
          onPressed: () {
            _newTnController.clear();
            tnInputNumberProv.clear();
          },
          icon: Icon(Icons.clear),
          color: Colors.black38,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(0),
              bottomLeft: Radius.circular(8),
              bottomRight: Radius.circular(0)),
          borderSide: BorderSide(
            width: 0,
            style: BorderStyle.none,
          ),
        ),
      ),
    );
  }
}
