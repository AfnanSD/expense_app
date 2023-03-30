import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../model/transactions.dart';

class TransactoinItem extends StatelessWidget {
  const TransactoinItem({
    Key? key,
    required this.transactino,
    required this.mediaQury,
    required this.removeMethod,
  }) : super(key: key);

  final transactions transactino;
  final MediaQueryData mediaQury;
  final Function removeMethod;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 10,
      ),
      child: ListTile(
        leading: Container(
          width: 120,
          margin: EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 5,
          ),
          decoration: BoxDecoration(
            border: Border.all(color: Color.fromARGB(255, 196, 195, 195)),
            borderRadius: BorderRadius.circular(5),
            color: Color.fromARGB(255, 237, 237, 237),
          ),
          padding: EdgeInsets.all(10),
          child: FittedBox(
            child: Text(
              '${transactino.amount.toStringAsFixed(2)} SR',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                //Color.fromARGB(255, 29, 91, 142),
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ),
        ),
        title: Text(
          transactino.title,
          style: TextStyle(
            color: Theme.of(context).primaryColor, // Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 17,
          ),
        ),
        subtitle: Text(
          DateFormat.yMMMEd().format(transactino.date),
          style: TextStyle(
            color: Color.fromARGB(255, 90, 122, 149),
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        trailing: mediaQury.size.width > 700
            ? TextButton.icon(
                onPressed: () => removeMethod(transactino.id),
                icon: Icon(
                  Icons.delete,
                  color: Colors.grey,
                ),
                label: Text('Delete', style: TextStyle(color: Colors.grey)),
              )
            : IconButton(
                onPressed: () => removeMethod(transactino.id),
                icon: Icon(Icons.delete)),
      ),
    );
  }
}
