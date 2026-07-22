import 'package:flutter/material.dart';
import 'appointments_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:docotorappointment/services/firestore_service.dart';

class BookingScreen extends StatefulWidget {
  final Map<String, dynamic> doctor;

  const BookingScreen({
    super.key,
    required this.doctor,
  });

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
   final FirestoreService firestoreService = FirestoreService();

  Future<void> pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> pickTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final doctor = widget.doctor;
    
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: const Color(0xFF607D8B),
        title: const Text("Book Appointment"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,

          children: [

            Text(
              doctor["name"]!,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              doctor["speciality"]??"",
              style: const TextStyle(fontSize: 18),
            ),

            const SizedBox(height: 40),

            ElevatedButton.icon(
              onPressed: pickDate,
              icon: const Icon(Icons.calendar_today),
              label: Text(
                selectedDate == null
                    ? "Select Date"
                    : "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton.icon(
              onPressed: pickTime,
              icon: const Icon(Icons.access_time),
              label: Text(
                selectedTime == null
                    ? "Select Time"
                    : selectedTime!.format(context),
              ),
            ),

            const Spacer(),

            SizedBox(
              height: 55,
              child: ElevatedButton(
                onPressed: ()async {

                  if (selectedDate == null || selectedTime == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Please select date and time"),
                      ),
                    );
                    return;
                  }

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Appointment Booked Successfully"),
                    ),
                  );
  
print(widget.doctor);
print("Saving speciality: '${widget.doctor["speciality"]}'");                 
await firestoreService.bookAppointment(
  userId: FirebaseAuth.instance.currentUser!.uid,
  doctorName: doctor["name"]!,
  specialty: doctor["speciality"]!,
  date: "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",
  time: selectedTime!.format(context),
);

Navigator.pushReplacement(
  context,
  MaterialPageRoute(
    builder: (_) => const AppointmentsScreen(),
  ),
);
},
                child: const Text(
                  "Confirm Appointment",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}