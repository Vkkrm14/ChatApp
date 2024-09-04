import 'package:flutter/material.dart';
class UserTile extends StatelessWidget {
  final String text;
  void Function()? onTap;
   UserTile({super.key,required this.onTap,required this.text});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding:EdgeInsets.all(20) ,
        margin: EdgeInsets.symmetric(vertical: 10,horizontal: 25),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          borderRadius: BorderRadius.circular(12),),
            child: Row(
              children: [
                Icon(Icons.person,color:Theme.of(context).colorScheme.inversePrimary ,),
                SizedBox(width: 20,),
                Text(text,style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),),
              ],

      ),
        ),
      );

  }
}
