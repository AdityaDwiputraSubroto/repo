import 'package:flutter/material.dart';
import 'package:repo/core/shared/colors.dart';
import 'package:repo/core/utils/formatting.dart';

bool _isObscure = true;
bool _isnotObscure = false;

class TextFieldRepo extends StatefulWidget {
  final TextEditingController textController;
  final String hintText;
  final bool obscureText;
  final bool multiLine;
  final bool isNumber;
  const TextFieldRepo(
      {super.key,
      required this.textController,
      required this.hintText,
      this.obscureText = false,
      this.multiLine = false,
      this.isNumber = false});

  @override
  State<TextFieldRepo> createState() => _TextFieldRepoState();
}

class _TextFieldRepoState extends State<TextFieldRepo> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType:
          widget.isNumber ? TextInputType.number : TextInputType.multiline,
      controller: widget.textController,
      maxLines: widget.multiLine == true ? null : 1,
      expands: widget.multiLine,
      obscureText: widget.obscureText == true ? _isObscure : _isnotObscure,
      decoration: InputDecoration(
        constraints: const BoxConstraints(
          maxHeight: 220,
          minHeight: 50,
        ),
        hintStyle: const TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 16,
        ),
        filled: true,
        fillColor: hexToColor(ColorsRepo.secondaryColor),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: hexToColor(ColorsRepo.primaryColor),
          ),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: hexToColor(ColorsRepo.primaryColor).withOpacity(0.8),
            width: 2,
          ),
        ),
        contentPadding: const EdgeInsets.fromLTRB(12, 18, 20, 10),
        suffixIcon: widget.obscureText == true
            ? IconButton(
                color: hexToColor(ColorsRepo.primaryColor),
                icon:
                    Icon(_isObscure ? Icons.visibility : Icons.visibility_off),
                onPressed: () {
                  setState(() {
                    _isObscure = !_isObscure;
                  });
                },
              )
            : null,
        hintText: widget.hintText,
      ),
    );
  }
}
