// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
class FinPlanAppBar extends StatelessWidget {

  const FinPlanAppBar({
    Key? key,
    this.title = '',
    required this.leadingIconAction,
    required this.leadingIcon, 
    required this.availableActions,
  }) : super(key: key);

  final String title;
  final IconData leadingIcon;
  final bool Function({String input}) leadingIconAction;
  final List<Map<IconData, bool Function({String input})>> availableActions;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      leading: IconButton(
        icon: Icon(leadingIcon),
        onPressed: () => leadingIconAction(),
      ),
      actions: [
        for (var each in availableActions)
          IconButton(
            icon: Icon(each.entries.first.key),
            onPressed: () => each.entries.first.value(),
          ),
        ],
      );
  }
  
  // generateActions() {
  //   List<IconButton> actions = [];
  //   Map<IconData, String? Function({String input})> each;
  //   for(each in availableActions){
  //     actions.add(
  //       IconButton(
  //         icon: Icon(each.entries.first.key),
  //         onPressed: each.entries.first.value,
  //       )
  //     );
  //   }
  // }

}
