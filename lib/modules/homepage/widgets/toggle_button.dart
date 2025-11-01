import 'package:flutter/material.dart';
import 'package:quick_bid/core/helper/texstylehelper.dart';

class ToggleButton extends StatelessWidget {
  final String text;
  final double width;
  final double height;
  final bool isActive; 
  final VoidCallback onTap; 

  const ToggleButton({
    super.key,
    required this.text,
    required this.width,
    required this.height,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: width,
        height: height,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          color: isActive ? Colors.black : Colors.white,  
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          text,
          style: isActive
              ? Texstylehelper.small14white500
              :Texstylehelper.small14blackw500,
        ),
      ),
    );
  }
}
