import 'package:flutter/material.dart';

class SearchHeader extends StatelessWidget {
  const SearchHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 73,
      decoration: BoxDecoration(
        color: Color(0xFF0B0B0B),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: Text(
          'Search',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w700,
            height: 1.40,
          ),
        ),
      ),
    );
  }
}
