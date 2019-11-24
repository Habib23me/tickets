import 'package:flutter/material.dart';
import 'package:tickets/service.dart';

void main() => runApp(
      MaterialApp(
        home: TicketsScreen(),
      ),
    );

class TicketsScreen extends StatelessWidget {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.redAccent,
        title: Text("Tickets"),
        leading: SoldTickets(),
      ),
      body: Center(
        child: MaterialButton(
          color: Colors.redAccent,
          onPressed: onSellTicket,
          shape: CircleBorder(),
          padding: EdgeInsets.all(35.0),
          child: Icon(Icons.monetization_on),
        ),
      ),
      bottomNavigationBar: Center(
        child: FlatButton(
          child: Text("Undo"),
          onPressed: onUndo,
        ),
      ),
    );
  }

  void onUndo() async {
    await undo();
    showSnackbar("You have succesfully removed your last update.");
  }

  void onSellTicket() async {
    await sellTicket();
    showSnackbar("New ticket was successfully sold.");
  }

  void showSnackbar(String message) {
    scaffoldKey.currentState
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text("$message")));
  }
}

class SoldTickets extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: soldTicketsStream(),
      builder: (_, snapshot) {
        if (!snapshot.hasData) return Center(child: Text("0"));
        return Center(
          child: Text("${snapshot.data}"),
        );
      },
    );
  }
}
