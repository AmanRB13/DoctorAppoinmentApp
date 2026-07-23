import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../services/firestore_service.dart';

class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({super.key});

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {
  @override
  Widget build(BuildContext context) {
    final firestore = FirestoreService();
  

    final userId = FirebaseAuth.instance.currentUser!.uid;
   
    
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: const Color(0xFF607D8B),
        title: const Text("My Appointments"),
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: firestore.getAppointments(userId),

        builder: (context, snapshot) {
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!snapshot.hasData ||
              snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text("No Appointments"),
            );
          }

          final docs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
  final appointment =
      docs[index].data() as Map<String, dynamic>;

  final docId = docs[index].id;

  print(appointment);

  return Card(
    elevation: 5,
    margin: const EdgeInsets.all(10),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15),
    ),
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            appointment["doctorName"] ?? "",
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          Row(
            children: [
              const Icon(Icons.medical_services),
              const SizedBox(width: 8),
              Text(appointment["speciality"] ?? ""),
            ],
          ),

          const SizedBox(height: 10),

          Row(
            children: [
              const Icon(Icons.calendar_today),
              const SizedBox(width: 8),
              Text(appointment["date"] ?? ""),
            ],
          ),

          const SizedBox(height: 10),

          Row(
            children: [
              const Icon(Icons.access_time),
              const SizedBox(width: 8),
              Text(appointment["time"] ?? ""),
            ],
          ),

          const SizedBox(height: 10),

          Row(
            children: [
              const Icon(
                Icons.check_circle,
                color: Colors.green,
              ),
              const SizedBox(width: 8),
              Text(
                appointment["status"] ?? "",
                style: const TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.white24),
              onPressed: () async {
                
  DateTime? newDate = await showDatePicker(
    context: context,
    firstDate: DateTime.now(),
    initialDate: DateTime.now(),
    lastDate: DateTime(2030),
  );

  if(newDate==null){
    return;
  }

  final doctorDoc = await FirebaseFirestore.instance.
  collection('123456').doc(appointment['doctorId']).get();

  List<String> slots = List<String>.from(doctorDoc['availableSlots']);
  String? selectedslot;
   final bool? save = await showDialog<bool>(
  context: context,
  builder: (context) {
    return StatefulBuilder(
      builder: (context, setDialogState) {
        return AlertDialog(
          title: const Text("Select a Time Slot"),
          content: Wrap(
            spacing: 10,
            runSpacing: 10,
            children: slots.map((slot) {
              final selected = slot == selectedslot;

              return ChoiceChip(
                label: Text(slot),
                selected: selected,
                selectedColor: Colors.green,
                onSelected: (_) {
                  setDialogState(() {
                    selectedslot = slot;
                  });
                },
              );
            }).toList(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  },
);
  


    if(save != true){
      return;

    }
    await firestore.rescheduleAppointment(
      id: docId,
      date: "${newDate.day}/${newDate.month}/${newDate.year}",
      time: selectedslot!,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Appointment Rescheduled"),
      ),
    );
  
},
              child: Text('Edit')),
          ),

        
          const SizedBox(height: 10),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              onPressed: () async {
                final bool? confirm = await showDialog(context: context, builder: (context){
                  return AlertDialog(
                    content: Text('Are you sure you want to cancel the appoinment?'),
                    actions: [
                      TextButton(onPressed: (){
                        Navigator.pop(context,false);
                      
                      }, child: Text('Cancel'))
                      ,
                      ElevatedButton(
                        style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.redAccent)),
                        onPressed: (){
                        Navigator.pop(context,true);

                      }, child: Text('Yes'))
                    ],
                    title: Text('Cancel Appointment'),
                    
                    

                  );
                  
                });
                if(confirm==true){
                  await firestore.cancelAppointment(docId);

                }
                

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Appointment Cancelled"),
                  ),
                );
              },
              child: const Text(
                "Cancel Appointment",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
           
          );
        },
      ),
    );
  }
}