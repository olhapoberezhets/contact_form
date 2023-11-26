import 'dart:convert';

import 'package:contact_form/text_form_row.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FormPage extends StatefulWidget {
  const FormPage({super.key});

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  String? _nameErrorText;
  String? _emailErrorText;
  String? _messageErrorText;
  bool _isNameValid = false;
  bool _isEmailValid = false;
  bool _isMessageValid = false;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  final Map<String, dynamic> _formData = {
    "name": "",
    "email": "",
    "message": "",
  };
  bool _isLoading = false;

  void _validateName(value) {
    if (value!.isEmpty ||
        value.length < 3 ||
        !RegExp(r'^[a-z A-Z]+$').hasMatch(value)) {
      setState(() {
        _nameErrorText = 'Please enter correct name';
        _isNameValid = false;
      });
    } else {
      setState(() {
        _nameErrorText = null;
        _isNameValid = true;
        _formData["name"] = value;
      });
    }
  }

  void _validateEmail(value) {
    if (value!.isEmpty ||
        !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}').hasMatch(value)) {
      setState(() {
        _emailErrorText = 'Please enter correct email';
        _isEmailValid = false;
      });
    } else {
      setState(() {
        _emailErrorText = null;
        _isEmailValid = true;
        _formData["email"] = value;
      });
    }
  }

  void _validateMessage(value) {
    if (value == null || value.isEmpty || value.length < 15) {
      setState(() {
        _messageErrorText = 'Please input minimum 15 characters';
        _isMessageValid = false;
      });
    } else {
      setState(() {
        _messageErrorText = null;
        _isMessageValid = true;
        _formData["message"] = value;
      });
    }
  }

  void _submitForm() async {
    if (_isNameValid && _isEmailValid && _isMessageValid) {
      String jsonData = jsonEncode(_formData);
      setState(() {
        _isLoading = true;
      });

      try {
        final response = await http.post(
          Uri.parse('https://api.byteplex.info/api/test/contact/'),
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonData,
        );

        if (response.statusCode == 201) {
          _clearFormFields();
          _showSuccessPopUp();
        } else {
          _showErrorPopUp(response);
        }
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        print('Error: $e');
      }
    }
  }

  void _clearFormFields() {
    setState(() {
      _nameController.clear();
      _emailController.clear();
      _messageController.clear();

      _isNameValid = false;
      _isEmailValid = false;
      _isMessageValid = false;

      _isLoading = false;
    });
  }

  Future<dynamic> _showErrorPopUp(http.Response response) {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => AlertDialog(
              title: const Text(
                'Whoops!',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Text('${response.statusCode} ${response.reasonPhrase}'),
              actions: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      _isLoading = false;
                    });
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                )
              ],
            ));
  }

  Future<dynamic> _showSuccessPopUp() {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => AlertDialog(
              title: const Text(
                'Success',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: const Text('Your message has been sent successfully'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                )
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Contact Us',
          style: TextStyle(
            color: Colors.black,
            fontSize: 25.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
            size: 25.0,
          ),
          onPressed: () {},
        ),
        backgroundColor: Colors.white,
        elevation: 0.0,
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            children: [
              TextFormRow(
                controller: _nameController,
                label: 'Name',
                errorText: _nameErrorText,
                onChanged: (value) => _validateName(value),
              ),
              TextFormRow(
                controller: _emailController,
                label: 'Email',
                errorText: _emailErrorText,
                onChanged: (value) => _validateEmail(value),
              ),
              TextFormRow(
                controller: _messageController,
                label: 'Message',
                errorText: _messageErrorText,
                onChanged: (value) => _validateMessage(value),
              ),
              const SizedBox(height: 20.0),
              TextButton(
                onPressed: _isNameValid && _isEmailValid && _isMessageValid
                    ? _submitForm
                    : () {},
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor:
                      _isNameValid && _isEmailValid && _isMessageValid
                          ? const Color(0xFF986d8e)
                          : Colors.grey.withOpacity(0.4),
                  minimumSize: Size(MediaQuery.of(context).size.width, 40.0),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  ),
                ),
                child: _isLoading
                    ? Image.asset(
                        'assets/loader.gif',
                        width: 24.0,
                        height: 24.0,
                      )
                    : const Text(
                        'Send',
                        style: TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
