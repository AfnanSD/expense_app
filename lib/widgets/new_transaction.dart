import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  NewTransaction({
    super.key,
    required this.addmethod,
  });

  final Function addmethod;

  @override
  State<NewTransaction> createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final amountController = TextEditingController();
  final titleController = TextEditingController();
  DateTime? datepicked;

  @override
  Widget build(BuildContext context) {
    final mediaQury = MediaQuery.of(context);
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(
            top: 10,
            right: 10,
            left: 10,
            bottom: mediaQury.viewInsets.bottom + 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Title',
                labelStyle: TextStyle(
                  color: Color.fromARGB(255, 90, 122, 149),
                ),
              ),
              controller: titleController,
              onSubmitted: (_) => submitData(),
            ),
            TextField(
              decoration: InputDecoration(
                labelText: 'Amount',
                labelStyle: TextStyle(
                  color: Color.fromARGB(255, 90, 122, 149),
                ),
              ),
              controller: amountController,
              keyboardType: TextInputType.number,
              onSubmitted: (_) => submitData(),
            ),
            Container(
              height: 70,
              child: Row(
                children: [
                  Expanded(
                    child: Text(datepicked == null
                        ? 'No date picked yet'
                        : 'date picked: ${DateFormat.yMd().format(datepicked!)}'),
                  ),
                  TextButton(
                    onPressed: presentDatePicker,
                    child: Text(
                      'Pick a date',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
            ),
            ElevatedButton(
              onPressed: submitData,
              child: Text("Add transaction"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 29, 91, 142),
              ),
            ),
          ],
        ),
      ),
    );
  }

  submitData() {
    final title = titleController.text;
    final amount = double.parse(amountController.text);
    if (title.isEmpty || amount < 0 || datepicked == null) {
      return;
    }
    widget.addmethod(title, amount, datepicked);
  }

  void presentDatePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2020),
            lastDate: DateTime.now())
        .then((value) {
      setState(() {
        if (value == null) return;
        datepicked = value;
      });
    });
  }
}
