import 'package:expense_app/widgets/transaction_item.dart';
import 'package:flutter/material.dart';

import '../model/transactions.dart';

class TransactionsList extends StatelessWidget {
  const TransactionsList(
      {super.key, required this.transactinos, required this.removeMethod});

  final List<transactions> transactinos;
  final Function removeMethod;

  @override
  Widget build(BuildContext context) {
    final mediaQury = MediaQuery.of(context);
    return Container(
      child: ListView.builder(
        itemBuilder: ((context, index) {
          return TransactoinItem(
              transactino: transactinos[index],
              mediaQury: mediaQury,
              removeMethod: removeMethod);
        }),
        itemCount: transactinos.length,
      ),
    );
  }
}
