import 'package:flutter/material.dart';

class CustomTextFieldWidget extends StatelessWidget {
  final TextEditingController? editingController;
  final String? hintText;
  final IconData? iconData;
  final String? assetRef;
  final String? labelText;
  final bool? isObscure;

  const CustomTextFieldWidget({
    super.key,
    this.editingController,
    this.hintText,
    this.iconData,
    this.assetRef,
    this.labelText,
    this.isObscure,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 13.0),
      child: TextField(
        controller: editingController,
        obscureText: isObscure ?? false,
        decoration: InputDecoration(
          prefixIcon: iconData != null
              ? Icon(iconData, color: Color(0xF4F63E67))
              : (assetRef != null
              ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset("images/$assetRef"),
          )
              : null),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(13.0),
            borderSide: const BorderSide(
              width: 1,
              color: Colors.grey,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(13.0),
            borderSide: BorderSide(
              width: 2,
              color: Colors.white,
            ),
          ),
          labelText: labelText,
          labelStyle: TextStyle(
            // color: Color(0xF4F63E67),
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          hintText: hintText,
        ),
      ),
    );
  }
}