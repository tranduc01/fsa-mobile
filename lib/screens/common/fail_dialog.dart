import 'package:flutter/material.dart';

class FailDialog extends StatelessWidget {
  final String text;
  const FailDialog({required this.text, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        width: 200,
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/images/fail.gif'),
            SizedBox(
              height: 20,
            ),
            Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
            SizedBox(height: 20),
            Text(
              'Please try again!',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: const Color.fromARGB(106, 0, 0, 0),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Try Again',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black),
                ),
                style: ButtonStyle(
                  backgroundColor: WidgetStateColor.resolveWith((states) {
                    if (states.contains(WidgetState.pressed)) {
                      return const Color.fromARGB(137, 244, 67, 54);
                    }
                    return Colors.white;
                  }),
                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(color: Colors.red, width: 2)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
