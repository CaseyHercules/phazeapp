import 'package:flutter/material.dart';

class Footer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final year = DateTime.now().year;
    return BottomAppBar(
      color: Theme.of(context).backgroundColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
              String.fromCharCodes(
                Runes('Interphaze LLC \u00a9 $year'),
              ),
              style: Theme.of(context).textTheme.subtitle2),
        ],
      ),
    );
  }
}
