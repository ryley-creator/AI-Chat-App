import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ContinueWith extends StatelessWidget {
  const ContinueWith({super.key, required this.text, required this.widget});
  final String text;
  final Widget widget;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text('- OR Continue with -'),
          SizedBox(height: 20),
          SvgPicture.asset('assets/icons/auth_methods.svg'),
          SizedBox(height: 28),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Text(text), widget],
          ),
        ],
      ),
    );
  }
}
