import 'package:cloud_firestore/cloud_firestore.dart';

void printPizzaData() async {
  try {
    // Fetch the documents from the 'pizzas' collection
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('pizzas').get();

    // Check if the collection has documents
    if (querySnapshot.docs.isNotEmpty) {
      for (var doc in querySnapshot.docs) {
        // Print each document's ID and data
        print('Document ID: ${doc.id}');
        print('Data: ${doc.data()}');
      }
    } else {
      print('No documents found in the pizzas collection.');
    }
  } catch (error) {
    print('Error fetching data: $error');
  }
}

void main() {
  // Call the function to print pizza data
  printPizzaData();
}
