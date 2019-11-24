import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

Firestore firestore = Firestore.instance;

DocumentReference get docRef =>
    firestore.collection("Tickets").document("devfest");

Future<void> undo() async {
  int amount = await getAmountSold();
  updateSold(--amount);
}

Future<void> sellTicket() async {
  int amount = await getAmountSold();
  updateSold(++amount);
  sendToTelegeramBot("Tickets were sold $amount");
}

///Update the document data.
///Specifically the sold property of the document.
Future<void> updateSold(int sold) async {
  docRef.updateData({"sold": sold});
}

///[bot958070913:AAFAyUuXhU1j2lN13iy8zLMS2zsEFI4I-t4] is the telegeram bot token from
///bot father.
///[-327697143] is the chatId of the chat the bot is communicating with.
///Check this to find chat_ids https://api.telegram.org/[BOT-TOKEN]/getChat
Future<void> sendToTelegeramBot(String message) async {
  http.post(
      "https://api.telegram.org/bot958070913:AAFAyUuXhU1j2lN13iy8zLMS2zsEFI4I-t4/sendMessage",
      body: {
        'chat_id': '-327697143',
        'text': '$message',
      });
}

///Amount of tickets sold as if right now.
Future<int> getAmountSold() async {
  return (await docRef.get())["sold"];
}

///Stream live updates of the document and maps each data to how many tickets are sold
Stream<int> soldTicketsStream() => docRef.snapshots().map((doc) => doc["sold"]);
