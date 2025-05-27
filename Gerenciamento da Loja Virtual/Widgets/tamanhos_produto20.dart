import 'package:flutter/material.dart';

import 'add_dialog_tamanho21.dart';

class TamanhosProduto extends FormField<List> {
  TamanhosProduto({
    required BuildContext context,
    List? valorInicial,
    FormFieldSetter<List>? onSaved,
    FormFieldValidator<List>? validador,
  }) : super(
         initialValue: valorInicial,
         onSaved: onSaved,
         validator: validador,
         builder: (estado) {
           return SizedBox(
             height: 34,
             child: GridView(
               padding: EdgeInsets.symmetric(vertical: 4),
               scrollDirection: Axis.horizontal,
               gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                 crossAxisCount: 1,
                 mainAxisSpacing: 8,
                 childAspectRatio: 0.5,
               ),
               children:
                   [
                     ...estado.value!.map((s) {
                         return GestureDetector(
                           onLongPress: () {
                             estado.didChange(estado.value!..remove(s));
                           },
                           child: Container(
                             decoration: BoxDecoration(
                               borderRadius: BorderRadius.all(
                                 Radius.circular(4),
                               ),
                               border: Border.all(
                                 color: Colors.pinkAccent,
                                 width: 3,
                               ),
                             ),
                             alignment: Alignment.center,
                             child: Text(
                               s,
                               style: TextStyle(color: Colors.white),
                             ),
                           ),
                         );
                       }).toList()
                       ..add(
                         GestureDetector(
                           onTap: () async{
                             String tamanho = await showDialog(
                               context: context,
                               builder: (context) => AddDialogTamanho(),
                             );
                             if (tamanho != null) estado.didChange(estado.value!..add(tamanho));
                           },
                           child: Container(
                             decoration: BoxDecoration(
                               borderRadius: BorderRadius.all(
                                 Radius.circular(4),
                               ),
                               border: Border.all(
                                 color: estado.hasError ? Colors.red : Colors.pinkAccent,
                                 width: 3,
                               ),
                             ),
                             alignment: Alignment.center,
                             child: Text(
                               '+',
                               style: TextStyle(color: Colors.white),
                             ),
                           ),
                         ),
                       ),
                   ].cast<Widget>(), // Cast para List<Widget>
             ),
           );
         },
       );
}
