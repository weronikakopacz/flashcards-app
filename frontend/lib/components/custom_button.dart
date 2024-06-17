import 'package:flutter/material.dart';

typedef CustomButtonCallback = void Function();

class CustomButton extends StatefulWidget {
  final String text;
  final CustomButtonCallback onPressed;
  final Color color;
  final Color hoverColor;
  final double width;
  final double height;
  final double borderRadius;
  final double borderWidth;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.color = const Color.fromARGB(255, 210, 179, 211),
    this.hoverColor = const Color.fromARGB(255, 180, 150, 181),
    this.width = 100.0,
    this.height = 40.0,
    this.borderRadius = 10.0,
    this.borderWidth = 1.0,
  });

  @override
  CustomButtonState createState() => CustomButtonState();
}

class CustomButtonState extends State<CustomButton> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        color: isHovered ? widget.hoverColor : widget.color,
        borderRadius: BorderRadius.circular(widget.borderRadius),
        border: Border.all(
          color: const Color.fromARGB(255, 195, 195, 195),
          width: widget.borderWidth,
          style: BorderStyle.solid,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: MouseRegion(
        onEnter: (_) {
          setState(() {
            isHovered = true;
          });
        },
        onExit: (_) {
          setState(() {
            isHovered = false;
          });
        },
        child: GestureDetector(
          onTap: widget.onPressed,
          child: Center(
            child: Text(
              widget.text,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }
}