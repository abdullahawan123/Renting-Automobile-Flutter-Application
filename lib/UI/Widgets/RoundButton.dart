import 'package:flutter/material.dart';

class RoundButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final bool loading ;
  const RoundButton({Key? key,
    required this.title,
    required this.onTap,
    this.loading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50),
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30.0),
            boxShadow: const [
              BoxShadow(
                blurRadius: 3,
                color: Colors.white70,
              )
            ]
          ),
          child: Center(
            child: loading ?
            const CircularProgressIndicator(strokeWidth: 4, color: Color(0xFF03DAC6),):
            Text(title, style: const TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),),
          ),
        ),
      ),
    );
  }
}
