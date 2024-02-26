import 'package:flutter/material.dart';

class AboutUs extends StatefulWidget {
  final String device;
  const AboutUs({
    super.key,
    required this.device,
  });

  @override
  State<AboutUs> createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        elevation: 0,
        leadingWidth: 40,
        leading: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: IconButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
          ),
        ),
        title: Text("About Us Madadguru",
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 15, right: 15, ),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    'WHO',
                    style: TextStyle(

                        fontSize: 35,
                        color: Colors.orange,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    'WE ARE',
                    style: TextStyle(
                        fontSize: 22,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: 10,
                  ),

                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    height: 40,
                    width: 5,
                    color: Color(0xff2BB79D),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Icon(
                    Icons.rocket_launch_outlined,
                    size: 30,
                    color: Color(0xff2BB79D),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    'LOREM IPSUM IS SIMPLY',
                    style: TextStyle(
                        fontSize: 22,
                        color: Color(0xff2BB79D),
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Container(
                    height: 140,
                    width: 3,
                    color: Colors.grey,
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: Text(
                        maxLines: 14,
                        textAlign: TextAlign.justify,
                        'We are a bunch of Techies on the Journey to make Education Simple and Affordable. But, is there a need?The worlds is Moving towards Artificial Intelligence, Machine Learning, Virtual Reality & Augmented Reality but the Education industry (Our institutes and teachers) is still not Comfortable with Technology.We want to guide our Teachers to make a swift Transition from Traditional to cutting edge methods of Imparting learning among Students.We are Consistently working towards making the Learning process simple and Affordable for the teachers as well as Students.',
                        style: TextStyle(
                            fontSize: 13,
                            color: Color(0XFF273B8E),
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    height: 40,
                    width: 5,
                    color: Colors.redAccent.shade100,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Icon(
                    Icons.rocket_launch_outlined,size: 30,
                    color: Colors.redAccent.shade100,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    'LOREM IPSUM IS SIMPLY',
                    style: TextStyle(
                        fontSize: 22,
                        color: Colors.redAccent.shade100,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),

              SizedBox(height: 10),

              Row(
                children: [
                  Container(
                    height: 120,
                    width: 3,
                    color: Colors.grey,
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: Text(
                        maxLines: 14,
                        textAlign: TextAlign.justify,
                        'We are a SAAS company building affordable technological solutions for the education industry.Our team has vast experience in education industry and we know how hard it is for the institutes & tutors to deliver Quality education consistently.We are trying to help you manage all the other work through our All in One Tech platform so that you can focus on the most important thing-Imparting Quality learning to your students.',
                        style: TextStyle(
                            fontSize: 13,
                            color: Color(0XFF273B8E),
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    height: 40,
                    width: 5,
                    color: Colors.orange,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Icon(
                    Icons.rocket_launch_outlined,
                    size: 30,
                    color: Colors.orange,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    'LOREM IPSUM IS SIMPLY',
                    style: TextStyle(
                        fontSize: 22,
                        color: Colors.orange,
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),

              SizedBox(height: 10),
              Row(
                children: [
                  Container(
                    height: 140,
                    width: 3,
                    color: Colors.grey,
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: Text(
                        maxLines: 14,
                        textAlign: TextAlign.justify,
                        'We follow a 3 step process to achieve you goal:First, our customer onboarding team will understand your business, target audience and your vision for your business.Then our customer support team with the help of our tech team will chalk out all your requirements and how to set your institute for the next phase of growth through eLearning.Or team will help you and your team to understand the custom built solution and will make it live once you are satisfied.That'
                        's not it, our customer support team is always there to help you throughout the course of our partnership.',
                        style: TextStyle(
                            fontSize: 13,
                            color: Color(0XFF273B8E),
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    height: 40,
                    width: 5,
                    color: Color(0xff2BB79D),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Icon(
                    Icons.rocket_launch_outlined,
                    size: 30,
                    color: Color(0xff2BB79D),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    'LOREM IPSUM IS SIMPLY',
                    style: TextStyle(
                        fontSize: 22,
                        color: Color(0xff2BB79D),
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),

              SizedBox(height: 10),
              Row(
                children: [
                  Container(
                    height: 140,
                    width: 3,
                    color: Colors.grey,
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: Text(
                        maxLines: 14,
                        textAlign: TextAlign.justify,
                        'We follow a 3 step process to achieve you goal:First, our customer onboarding team will understand your business, target audience and your vision for your business.Then our customer support team with the help of our tech team will chalk out all your requirements and how to set your institute for the next phase of growth through eLearning.Or team will help you and your team to understand the custom built solution and will make it live once you are satisfied.That'
                            's not it, our customer support team is always there to help you throughout the course of our partnership.',
                        style: TextStyle(
                            fontSize: 13,
                            color: Color(0XFF273B8E),
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 40,),
            ],
          ),
        ),
      ),
    );
  }
}
