// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

int final_mode_pay = 0;

class payment_poll extends StatefulWidget {
  @override
  _PaymentPollState createState() => _PaymentPollState();
}

class _PaymentPollState extends State<payment_poll> {
  String _selectedOption = '';
  int _selectedIndex = -1;

  void _selectOption(int index, String option) {
    setState(() {
      _selectedIndex = index + 1;
      final_mode_pay = _selectedIndex;
      _selectedOption = option;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('You selected: $option')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            PollOption(
              title: 'Cash On Dellivery',
              isSelected: _selectedIndex == 1,
              onTap: () => _selectOption(0, 'Cash'),
            ),
            PollOption(
              title: 'Credit',
              isSelected: _selectedIndex == 3,
              onTap: () => _selectOption(2, 'Credit'),
            ),
            // PollOption(
            //   title: 'Pay later',
            //   isSelected: _selectedIndex == 2,
            //   onTap: () => _selectOption(2, 'Pay later'),
            // ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class PollOption extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const PollOption({
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 8,
              backgroundColor: Colors.grey,
              child: CircleAvatar(
                radius: 4,
                backgroundColor: isSelected ? Colors.black : Colors.grey,
              ),
            ),
            SizedBox(width: 10),
            Text(
              title,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
