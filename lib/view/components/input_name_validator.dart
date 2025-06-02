import 'package:chat/core/controller/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InputNameValidator extends StatefulWidget {
  final TextEditingController name;
  final void Function(bool isValid) isValidated;
  final String? Function(String?)? validator;

  const InputNameValidator({
    super.key,
    this.validator,
    required this.name,
    required this.isValidated,
  });

  @override
  State<InputNameValidator> createState() => _InputNicknameValidatorState();
}

class _InputNicknameValidatorState extends State<InputNameValidator> {
  Widget selectIconByValidator(bool isValidNick) {
    return isValidNick
        ? const Icon(
            Icons.check,
            color: Color.fromARGB(120, 29, 134, 33),
          )
        : const Icon(
            Icons.close,
            color: Color.fromARGB(120, 134, 18, 3),
          );
  }

  @override
  Widget build(BuildContext context) {
    final userController = Provider.of<UserController>(context);
    return TextFormField(
      key: widget.key,
      controller: widget.name,
      validator: widget.validator,
      decoration: InputDecoration(
        label: const Text('Apelido'),
        suffixIcon: FutureBuilder(
            future: userController.isValidUserName(widget.name.text),
            builder: (context, snapshot) {
              if (!snapshot.hasData || widget.name.text.length < 4) {
                return const Text('');
              }

              final data = snapshot.data ?? false;

              widget.isValidated(data);

              return selectIconByValidator(data);
            }),
      ),
    );
  }
}
