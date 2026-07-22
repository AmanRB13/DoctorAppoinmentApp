import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailsScreen extends StatelessWidget {
  const DetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(title: Text('Details Screen'),
      actions: [
        IconButton(onPressed: (){
          Navigator.pushReplacementNamed(context, '/home');

        }, icon: Icon(Icons.arrow_back))
      ],
      backgroundColor: Colors.blueGrey,),
     body: SingleChildScrollView(
      padding: EdgeInsets.all(12),
       child: Column(
        
         children: [
         
          
           CircleAvatar(
        radius: 60,
        backgroundImage: AssetImage('assets/images/aman.jpg')
           ),
           SizedBox(height: 10,),
           Text('Aman Ranabhat',style: TextStyle(fontSize: 26,fontWeight: FontWeight.bold,color: Colors.black),),
           const SizedBox(height: 
           20,),
            Text('Computer Engineering Student',style: TextStyle(fontSize: 26,color: Colors.grey),),
           const SizedBox(height: 
           20,),
           const SizedBox(height: 15,),
           Card(
            child: ListTile(
              leading: Icon(Icons.school),
              title: Text('Eduacation'),
              subtitle: Text('3rd Year Computer Engineering Student'),

            ),
           ),
           const SizedBox(height: 15,),
           Card(
             child: ListTile(
              leading: Icon(Icons.person),
              title: Text('About Me',),
              subtitle: const Text('"I am passionate about software development and enjoy building mobile apps, websites, and machine learning projects. I am currently learning Deep Learning and improving my problem-solving skills.'),
             ),
           ),
           Card(child: ListTile(
            leading: Icon(Icons.code),
            title: Text('Skills'),
            subtitle: Text(
               "Flutter\n"
                  "Dart\n"
                  "Python\n"
                  "React\n"
                  "Django\n"
                  "Machine Learning\n"
                  "Deep Learning\n"
                  "Firebase",
              
              
              
              
              ),
           ),),
           Card(
              child: ListTile(
                leading: const Icon(Icons.favorite),
                title: const Text("Hobbies"),
                subtitle: const Text(
                    "Coding, Learning New Technologies, Reading Tech Blogs"),
              ),
            ),
             Card(
              child: ListTile(
                leading: const Icon(Icons.work),
                title: const Text("Projects"),
               subtitle: const Text(
  "• Doctor Appointment App\n"
  "• Automatic Grading System\n"
  "• Waste Detection using YOLOv8\n"
  "• IPL Score Predictor\n"
  "• Messaging App\n"
  "• Django Todo Site\n"
  "• Blog Site",
  style: TextStyle(
    fontSize: 14,
    
  ),
),
              ),
),
           
    ElevatedButton.icon(
  onPressed: () async {
    final Uri githubUri = Uri.parse('https://github.com/AmanRB13');

    if (await canLaunchUrl(githubUri)) {
      await launchUrl(
        githubUri,
        mode: LaunchMode.externalApplication,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not open GitHub'),
        ),
      );
    }
  },
  icon: const FaIcon(FontAwesomeIcons.github),
  label: const Text('Contact Me'),
),       
           
           
         ],
       ),
     ), 
    );
  }
}