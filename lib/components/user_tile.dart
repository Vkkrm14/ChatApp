import 'package:flutter/material.dart';
class UserTile extends StatelessWidget {
  final String text;
  final String text2;
  final IconData icon ;
  void Function()? onTap;
  UserTile({super.key,required this.onTap,required this.icon,required this.text,required this.text2});

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon,color:Theme.of(context).colorScheme.inversePrimary ,),
                SizedBox(width: 20,),
                Text(text,style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary,fontWeight: FontWeight.bold,fontSize: 20),),
              ],


            ),
            //SizedBox(height: 2,),
            Padding(
              padding: const EdgeInsets.only(left: 42),
              child: Text(text2,style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),),
            ),

          ],
        ),
      ),
    );

  }
}