import 'package:docotorappointment/screens/booking_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:docotorappointment/services/firestore_service.dart';
class DoctorDetailsScreen extends StatefulWidget {
final Map<String, dynamic> doctor;
  final String doctorId;

  

  const DoctorDetailsScreen({
    super.key,
    required this.doctor,
    required this.doctorId,
  });

  @override
  State<DoctorDetailsScreen> createState() => _DoctorDetailsScreenState();

 static Widget _timeChip(String time) {
    return Chip(
      label: Text(time),
      backgroundColor: Colors.blue.shade100,
    );
  }
 
}

class _DoctorDetailsScreenState extends State<DoctorDetailsScreen> {
  final TextEditingController reviewController = TextEditingController();
  double rating = 0.0;
  final FirestoreService firestoreService = FirestoreService();
  @override
  Widget build(BuildContext context) {

    
    
    return Scaffold(
      
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: const Color(0xFF607D8B),
        title: const Text("Doctor Details"),
      ),
      body: SingleChildScrollView(
        
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            CircleAvatar(
              radius: 60,
              backgroundImage: NetworkImage(widget.doctor["image"]??""),
            ),

            const SizedBox(height: 20),

            Text(
              widget.doctor["name"]??"",
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              widget.doctor["speciality"]??"",
              style: const TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 20),

            Card(
              child: ListTile(
                leading: const Icon(Icons.work),
                title: const Text("Experience"),
                subtitle: Text(widget.doctor["experience"]??""),
              ),
            ),

            Card(
              child: ListTile(
                leading: const Icon(Icons.attach_money),
                title: const Text("Consultation Fee"),
                subtitle: Text(widget.doctor["fee"]??""),
              ),
            ),
          Card(
  child: FutureBuilder(
    future: Future.wait([
      firestoreService.getAverageRating(widget.doctorId),
      firestoreService.getTotalReviews(widget.doctorId),
    ]),
    builder: (context, snapshot) {
      if (!snapshot.hasData) {
        return const ListTile(
          leading: Icon(Icons.star, color: Colors.amber),
          title: Text("Average Rating"),
          subtitle: Text("Loading..."),
        );
      }

      final average = snapshot.data![0] as double;
      final total = snapshot.data![1] as int;

      return ListTile(
        leading: const Icon(Icons.star, color: Colors.amber),
        title: const Text("Average Rating"),
        subtitle: Text(
          "${average.toStringAsFixed(1)} ⭐ ($total reviews)",
        ),
      );
    },
  ),
),  

Card(
  child: FutureBuilder<String>(
    future: firestoreService.getReviews(
      docId: widget.doctorId,
      
      userId: FirebaseAuth.instance.currentUser!.uid,
    ),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const ListTile(
          leading: Icon(Icons.reviews),
          title: Text("Your Review"),
          subtitle: Text("Loading..."),
        );
      }

      return ListTile(
        leading: const Icon(Icons.reviews),
        title: const Text("Your Review"),
        subtitle: Text(snapshot.data ?? "No review yet"),
      );
    },
  ),
),


            const SizedBox(height: 20),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "About Doctor",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 10),

            Text(
  widget.doctor["description"]??"",
  style: const TextStyle(fontSize: 16),
),

            const SizedBox(height: 25),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Available Time Slots",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 15),

            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                DoctorDetailsScreen._timeChip("9:00 AM"),
                DoctorDetailsScreen._timeChip("10:30 AM"),
                DoctorDetailsScreen._timeChip("12:00 PM"),
                DoctorDetailsScreen._timeChip("2:00 PM"),
                DoctorDetailsScreen._timeChip("4:00 PM"),
              ],
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookingScreen(
          doctor: widget.doctor,
        ),
      ),
    );
  },
  child: const Text("Book Appointment"),
),
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber,
              ),
              onPressed: (){
              showDialog(context: context, builder: (context){
                return AlertDialog(
                  title: const Text('Rate Your Experience'),
                 
                
                   content: Column(
  mainAxisSize: MainAxisSize.min,
  children: [
    TextField(
      controller: reviewController,
      maxLines: 3,
      decoration: const InputDecoration(
        hintText: "Write Your Review",
        border: OutlineInputBorder(),
      ),
    ),
    const SizedBox(height: 20),
    RatingBar.builder(
      initialRating: 0,
      minRating: 1,
      allowHalfRating: true,
      itemCount: 5,
      itemBuilder: (context, _) => const Icon(
        Icons.star,
        color: Colors.amber,
      ),
      onRatingUpdate: (value) {
        rating = value;
      },
    ),
  ],
),

                  actions: [
                    TextButton(onPressed: (){
                      Navigator.pop(context);

                    }, child: Text('Cancel')),
                    ElevatedButton(
  onPressed: () async {
    if (rating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select a rating"),
        ),
      );
      return;
    }

    await firestoreService.submitRating(
      doctorId: widget.doctorId,
      userId: FirebaseAuth.instance.currentUser!.uid,
      rating: rating,
      review : reviewController.text,
    );

    Navigator.pop(context);

    setState(() {});

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("You rated $rating ⭐"),
      ),
    );
  },
  child: const Text("Submit"),
),
                    

                  ],


                );
              });
              

            }, 
            
            icon: Icon(Icons.star_rate_rounded),
            label: Text('Rate your experience'))
            
            
          ],
        ),
      ),
    );
  }
}