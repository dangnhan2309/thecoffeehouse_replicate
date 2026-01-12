// import 'dart:async';
//
// import 'package:flutter/cupertino.dart';
//
// class CountdownTimer extends StatefulWidget {
//   final Duration initialDuration; // Ví dụ: Duration(hours: 3, minutes: 19, seconds: 34)
//
//   const CountdownTimer({Key? key, required this.initialDuration}) : super(key: key);
//
//   @override
//   State<CountdownTimer> createState() => _CountdownTimerState();
// }
//
// class _CountdownTimerState extends State<CountdownTimer> {
//   late Duration remaining;
//   Timer? _timer;
//
//   @override
//   void initState() {
//     super.initState();
//     remaining = widget.initialDuration;
//     _timer = Timer.periodic(const Duration(seconds: 1), (_) {
//       if (remaining.inSeconds > 0) {
//         setState(() {
//           remaining = remaining - const Duration(seconds: 1);
//         });
//       } else {
//         _timer?.cancel();
//       }
//     });
//   }
//
//   @override
//   void dispose() {
//     _timer?.cancel();
//     super.dispose();
//   }
//
//   String _formatDuration(Duration d) {
//     String twoDigits(int n) => n.toString().padLeft(2, '0');
//     final hours = twoDigits(d.inHours);
//     final minutes = twoDigits(d.inMinutes.remainder(60));
//     final seconds = twoDigits(d.inSeconds.remainder(60));
//     return '$hours:$minutes:$seconds';
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Text(
//       _formatDuration(remaining),
//       style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//     );
//   }
// }