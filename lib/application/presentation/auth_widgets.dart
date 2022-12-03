// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';

// import '../../constants/my_colors.dart';

// class TOSCheckbox extends StatefulWidget {
//   const TOSCheckbox({super.key});

//   @override
//   State<TOSCheckbox> createState() => _TOSCheckboxState();
// }

// class _TOSCheckboxState extends State<TOSCheckbox> {
//   @override
//   Widget build(BuildContext context) {
//     bool isChecked = false;
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.start,
//       children: [
//         Checkbox(
//           checkColor: MyColors.colorFFFFFF,
//           activeColor: MyColors.colorFB65BA,
//           side: MaterialStateBorderSide.resolveWith(
//             (states) => const BorderSide(width: 1.5, color: MyColors.color9B9A9B),
//           ),
//           value: isChecked,
//           onChanged: (bool? value) {
//             setState(() {
//               isChecked = value!;
//             });
//           },
//         ),
//         Flexible(
//           child: RichText(
//             overflow: TextOverflow.visible,
//             text: TextSpan(
//               text: 'I agree to the ',
//               style: Theme.of(context).textTheme.bodyMedium,
//               children: <TextSpan>[
//                 TextSpan(
//                   recognizer: TapGestureRecognizer()
//                     ..onTap = () {
//                       // TODO: Implement TOS and privacy policy link
//                     },
//                   text: "Terms of services and Privacy Policy",
//                   style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: MyColors.colorFB65BA),
//                 ),
//               ],
//             ),
//           ),
//         )
//       ],
//     );
//   }
// }
