import 'package:flutter/material.dart';
import 'appointments_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:docotorappointment/services/firestore_service.dart';

class BookingScreen extends StatefulWidget {
  final Map<String, dynamic> doctor;
  final String doctorId;

  const BookingScreen({
    super.key,
    required this.doctor,
    required this.doctorId,
  });

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}



class _BookingScreenState extends State<BookingScreen> {

  DateTime? selectedDate;
  String?  selectedTime;
  List<String> bookedSlots = [];

  
  
   final FirestoreService firestoreService = FirestoreService();

  Future<void> pickDate() async {
  final DateTime? picked = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime.now(),
    lastDate: DateTime(2030),
  );

  if (picked == null) return;

  // Doctor's working days
  final List<String> workingDays =
      List<String>.from(widget.doctor["WorkingDays"] ?? []);

  // Doctor's leave dates
  final List<String> leaveDates =
      List<String>.from(widget.doctor["leaveDates"] ?? []);

  // Convert weekday number to name
  const weekdays = [
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday",
  ];

  String selectedDay = weekdays[picked.weekday - 1];

  // Convert selected date to Firestore format
String selectedDateString =
    "${picked.year}-"
    "${picked.month.toString().padLeft(2, '0')}-"
    "${picked.day.toString().padLeft(2, '0')}";

  // Check if doctor works on this day
  if (!workingDays.contains(selectedDay)) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Doctor is unavailable on $selectedDay",
        ),
      ),
    );
    return;
  }

  // Check leave dates
  if (leaveDates.contains(selectedDateString)) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Doctor is on leave on this date."),
      ),
    );
    return;
  }

  // Date is valid
  setState(() {
    selectedDate = picked;
    selectedTime = null;
  });

  await checkBookedSlots();
}

  Future<void> checkBookedSlots() async {
  if (selectedDate == null) return;

  final date =
      "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}";

  final slots = await firestoreService.getBookedSlots(
    doctorId: widget.doctorId,
    date: date,
  );

  setState(() {
    bookedSlots = slots;

    if (selectedTime != null &&
        bookedSlots.contains(selectedTime)) {
      selectedTime = null;
    }
  });

  print("Booked Slots: $bookedSlots");
}



  @override
  Widget build(BuildContext context) {
    final doctor = widget.doctor;
    print(widget.doctor);
    print(doctor);
print(doctor.keys);
print(doctor["workingDays"]);
    final List<String> availableSlots =
    List<String>.from(doctor['availableSlots'] ?? []);
    final List<String> workingDays =
      List<String>.from(doctor["WorkingDays"] ?? []);

  final List<String> leaveDates =
      List<String>.from(doctor["leaveDates"] ?? []);
    
    
   
    
    
  
    
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: const Color(0xFF607D8B),
        title: const Text("Book Appointment"),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
        
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
        
            children: [
        
              Text(
                doctor["name"]!,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
        
              const SizedBox(height: 8),
        
              Text(
                doctor["speciality"]??"",
                style: const TextStyle(fontSize: 18,color: Colors.black),
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
        
              const SizedBox(height: 25),
        
        const Text(
          "Available Time Slots",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      if (selectedDate == null)
  const Text(
    "Please select a date first.",
    style: TextStyle(color: Colors.grey),
  )
else if (bookedSlots.length == availableSlots.length)
  const Text(
    "No appointment slots available.",
    style: TextStyle(
      color: Colors.red,
      fontWeight: FontWeight.bold,
    ),
  )
else
  Wrap(
    spacing: 10,
    runSpacing: 10,
    children: availableSlots.map((slot) {
      final isBooked = bookedSlots.contains(slot);

      return ChoiceChip(
        label: Text(
          isBooked ? "$slot (Booked)" : slot,
        ),
        selected: selectedTime == slot,
        selectedColor: Colors.green,
        disabledColor: Colors.brown,
        onSelected: isBooked
            ? null
            : (_) {
                setState(() {
                  selectedTime = slot;
                });
              },
      );
    }).toList(),
  ),
        
        const SizedBox(height: 12),
        
        
              const SizedBox(height: 30),
        
              
              Text("Working  days",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18,color: Colors.black),),
             
             Wrap(
  spacing: 10,
  runSpacing: 10,
  children: workingDays.map((day) {
    return Chip(
      label: Text(
        day,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }).toList(),
),
const SizedBox(height: 10,),
Text('Leave Dates',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.black),),
Wrap(
  spacing: 10,
  runSpacing: 10,
  children: leaveDates.map((date){
    return Chip(
      
      label: Text(date,style: TextStyle(color: Colors.white),));

  }).toList()
),
const SizedBox(height: 250,),


SizedBox(
                height: 55,
                child: ElevatedButton(
                  onPressed: ()async {
                 if(selectedDate == null || selectedTime== null){
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please Select the Date and Time')));
          return;
        }
        
        final bool? confirm = await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
        title: const Text("Book Appointment"),
        content: const Text("Are you sure?"),
        actions: [
          TextButton(
            style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.red)),
            
            onPressed: () {
              Navigator.pop(context, false);
            },
            
            child: const Text("No"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            onPressed: () {
              Navigator.pop(context, true);
            },
            child: const Text("Book"),
          ),
        ],
            );
          },
        );
        
        if (confirm != true) {
          return;
        }
        
        
        // Only reaches here if Book was pressed
        if (bookedSlots.contains(selectedTime)) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
        content: Text("This slot has already been booked."),
            ),
          );
          return;
        }
        await firestoreService.bookAppointment(
           doctorId: widget.doctorId,
          userId: FirebaseAuth.instance.currentUser!.uid,
          doctorName: doctor["name"]!,
          specialty: doctor["speciality"]!,
          date:
        "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",
          time: selectedTime!,
        );
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Appointment Booked Successfully"),
          ),
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
      ),
    );
  }
  
}