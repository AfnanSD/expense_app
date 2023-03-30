import 'dart:io';

import 'package:expense_app/widgets/chart.dart';
import 'package:expense_app/widgets/new_transaction.dart';
import 'package:expense_app/widgets/transaction_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'model/transactions.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitUp,
  //   DeviceOrientation.portraitDown,
  // ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expenses App',
      home: MyHomePage(),
      theme: ThemeData(
        colorSchemeSeed: Colors.blueGrey,
        fontFamily: 'Quicksand',
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<transactions> transactinos = [];
  bool _showChart = false;

  void _addTransactions(String title, double amount, DateTime datePicked) {
    transactions tx = new transactions(
      id: DateTime.now().toString(),
      title: title,
      amount: amount,
      date: datePicked,
    );
    setState(() {
      transactinos.add(tx);
    });
    Navigator.of(context).pop();
  }

  void _deleteTransaction(String id) {
    setState(() {
      transactinos.removeWhere((element) => element.id == id);
    });
  }

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return NewTransaction(addmethod: _addTransactions);
      },
    );
  }

  List<transactions> _getRecentTransactions() {
    return transactinos.where((element) {
      return element.date.isAfter(DateTime.now().subtract(Duration(days: 7)));
      //element.title.isNotEmpty || element.title.isEmpty;
    }).toList();
  }

  List<Widget> _buildLandscapeMode(
      MediaQueryData mediaQury, PreferredSizeWidget appPar, Widget listWidget) {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('show chart?'),
          Switch(
            value: _showChart,
            onChanged: (value) {
              setState(() {
                _showChart = !_showChart;
              });
            },
          )
        ],
      ),
      _showChart
          ? Container(
              height: (mediaQury.size.height -
                      appPar.preferredSize.height -
                      mediaQury.padding.top) *
                  0.7,
              child: Chart(recentTransactions: _getRecentTransactions()))
          //UserTransactions(),
          : listWidget,
    ];
  }

  List<Widget> _buildPortraitMode(
      MediaQueryData mediaQury, PreferredSizeWidget appPar, Widget listWidget) {
    return [
      Container(
          height: (mediaQury.size.height -
                  appPar.preferredSize.height -
                  mediaQury.padding.top) *
              0.2,
          child: Chart(recentTransactions: _getRecentTransactions())),
      listWidget,
    ];
  }

  PreferredSizeWidget _buildAppbar() {
    if (Platform.isAndroid) {
      return AppBar(
        title: const Text('Expenses App'),
        actions: [
          IconButton(
            onPressed: () {
              _startAddNewTransaction(context);
            },
            icon: Icon(Icons.add),
          ),
        ],
      );
    } else {
      return CupertinoNavigationBar(
        middle: const Text(
          'Expenses App',
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            GestureDetector(
              child: Icon(CupertinoIcons.add),
              onTap: () => _startAddNewTransaction(context),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQury = MediaQuery.of(context);
    final portraitMode = mediaQury.orientation == Orientation.portrait;
    final appPar = _buildAppbar();
    final listWidget = Container(
      height: (mediaQury.size.height -
              appPar.preferredSize.height -
              mediaQury.padding.top) *
          0.8,
      child: TransactionsList(
          transactinos: transactinos, removeMethod: _deleteTransaction),
    );
    return Scaffold(
      appBar: appPar,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (!portraitMode)
              ..._buildLandscapeMode(mediaQury, appPar, listWidget),
            if (portraitMode)
              ..._buildPortraitMode(mediaQury, appPar, listWidget),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          _startAddNewTransaction(context);
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
