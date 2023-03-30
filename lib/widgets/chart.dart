import 'package:expense_app/model/transactions.dart';
import 'package:expense_app/widgets/chart_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';

class Chart extends StatelessWidget {
  const Chart({super.key, required this.recentTransactions});

  final List<transactions> recentTransactions;

  List<Map<String, Object>> get getGroubedTransactionsValues {
    return List.generate(7, (index) {
      final weekday = DateTime.now().subtract(Duration(days: index));
      var sum = 0.0;
      for (var element in recentTransactions) {
        if (element.date.day == weekday.day &&
            element.date.month == weekday.month &&
            element.date.year == weekday.year) {
          sum += element.amount;
        }
      }
      return {'day': DateFormat.E().format(weekday), 'amount': sum};
    }).reversed.toList();
  }

  double get totalAmount {
    return getGroubedTransactionsValues.fold(0.0, (previousValue, element) {
      return previousValue += element['amount'] as double;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        elevation: 6,
        margin: EdgeInsets.all(20),
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: getGroubedTransactionsValues.map((e) {
              return Flexible(
                fit: FlexFit.tight,
                child: ChartBar(
                    label: e['day'] as String,
                    spendingAmount: e['amount'] as double,
                    spendingPctOfAmount: totalAmount == 0.0
                        ? 0.0
                        : (e['amount'] as double) / totalAmount),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
