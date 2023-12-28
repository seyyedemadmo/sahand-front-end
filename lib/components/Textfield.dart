import "package:flutter/material.dart";

class TextFieldYellowTransparent extends StatefulWidget {
  final String _label;
  final TextEditingController _controller;
  const TextFieldYellowTransparent(this._label, this._controller, {super.key});

  @override
  State<TextFieldYellowTransparent> createState() =>
      _TextFieldYellowTransparentState(_label, _controller);
}

class _TextFieldYellowTransparentState extends State<TextFieldYellowTransparent> {
  final String _label;
  final TextEditingController _controller;
  _TextFieldYellowTransparentState(this._label,this._controller);

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: const TextStyle(color: Colors.white, fontSize: 20),
      controller: _controller,
      decoration: InputDecoration(
          enabledBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(15)),
              borderSide: BorderSide(
                  color: Color.fromARGB(255, 187, 143, 0), width: 3)),
          focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(15)),
              borderSide: BorderSide(
                  color: Color.fromARGB(255, 255, 196, 0), width: 4.5)),
          label: Text(
            _label,
            style: const TextStyle(
                color: Color.fromARGB(255, 255, 196, 0),
                fontSize: 18,
                fontWeight: FontWeight.bold),
          )),
    );
  }
}

class TextFieldPasswordYellowTransparent extends StatefulWidget {
  final String _label;
  final TextEditingController _controller;
  const TextFieldPasswordYellowTransparent(this._label,this._controller,  {super.key});

  @override
  State<TextFieldPasswordYellowTransparent> createState() =>
      _TextFieldPasswordYellowTransparentState(_label,_controller);
}

class _TextFieldPasswordYellowTransparentState
    extends State<TextFieldPasswordYellowTransparent> {
  final String _label;
  final TextEditingController _controller;
  bool _password_visiblity = true;

  _TextFieldPasswordYellowTransparentState(this._label, this._controller);
  @override
  Widget build(BuildContext context) {
    return TextField(
      style: const TextStyle(color: Colors.white, fontSize: 20),
      obscureText: _password_visiblity,
      controller: _controller,
      decoration: InputDecoration(
          suffixIcon: IconButton(
              icon: Icon(
                // Based on passwordVisible state choose the icon
                _password_visiblity ? Icons.visibility : Icons.visibility_off,
                color: Color.fromARGB(255, 255, 196, 0),
              ),
              onPressed: () {
                // Update the state i.e. toogle the state of passwordVisible variable
                setState(() {
                  _password_visiblity = !_password_visiblity;
                });
              }),
          enabledBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(15)),
              borderSide: BorderSide(
                  color: Color.fromARGB(255, 187, 143, 0), width: 3)),
          focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(15)),
              borderSide: BorderSide(
                  color: Color.fromARGB(255, 255, 196, 0), width: 4.5)),
          label: Text(
            _label,
            style: const TextStyle(
                color: Color.fromARGB(255, 255, 196, 0),
                fontSize: 18,
                fontWeight: FontWeight.bold),
          )),
    );
    ;
  }
}
