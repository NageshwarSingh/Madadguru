import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FAqScreen extends StatefulWidget {
  final String device;
  const FAqScreen({super.key, required this.device});

  @override
  State<FAqScreen> createState() => _FAqScreenState();
}

class _FAqScreenState extends State<FAqScreen> {
  List<dynamic> Questions = [
    "Q1: What is Madadguru NGO's mission?",
    "Q2: How does Madadguru provide legal assistance?",
    "Q3: What services does Madadguru offer in real estate and property matters?",
    "Q4: How does Madadguru contribute to community development?",
    "Q5: Does Madadguru provide financial assistance?",
    "Q6: How can one volunteer or contribute to Madadguru's efforts?",
    "Q7: Where does Madadguru operate in India?",
    "Q8: Is Madadguru affiliated with any government bodies?",
    "Q9: How transparent is Madadguru with its financial transactions?",
    "Q10: Can individuals from any background seek assistance from Madadguru?",
  ];
List<dynamic> Answers=[

  "Madadguru NGO's mission is to empower individuals in India by providing comprehensive assistance in legal matters, real estate, property issues, community development, and financial support. The organization is committed to creating a more just and equitable society.",
  "Madadguru offers pro bono legal aid, guiding individuals through legal processes, representing them in court, and advocating for the rights of marginalized communities. The organization aims to ensure that everyone has access to justice, regardless of their financial status.",
  "Madadguru addresses issues such as land disputes, property rights, and illegal land grabs. The organization works to protect individuals from exploitation, promoting secure environments and stability within communities.",
  "Madadguru engages in community-building projects, educational programs, and health initiatives. By fostering social cohesion and addressing various community needs, the NGO aims to uplift the overall well-being of the communities it serves.",
  "Yes, Madadguru offers financial assistance and guidance to individuals facing economic challenges. The organization strives to empower individuals to overcome financial obstacles and build sustainable futures for themselves and their families.",
  "Individuals interested in supporting Madadguru can inquire about volunteer opportunities, make financial contributions, or participate in awareness campaigns. The NGO welcomes those willing to lend their time, skills, or resources to further its mission.",
  "Madadguru operates across various regions in India, reaching out to communities in need of legal, real estate, property, community, and financial assistance.",
  "Madadguru is a non-governmental organization and operates independently. While it may collaborate with government agencies on certain initiatives, it maintains autonomy to effectively address the diverse needs of the communities it serves.",
  "Madadguru is committed to transparency. The NGO regularly publishes financial reports, detailing income and expenses. Donors and supporters can access this information to ensure accountability and trust in the organization's operations.",
  "Yes, Madadguru is committed to serving individuals from all backgrounds. The organization's services are designed to be inclusive, ensuring that anyone facing legal, real estate, property, community, or financial challenges can seek assistance and support.",
];
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
        title: Text(
          "Faq/Help",
          style: GoogleFonts.roboto(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListView.builder(
              itemCount: 10,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Color(0xffFFEADD),
                      borderRadius: BorderRadius.circular(15)),
                  child: Theme(
                    data: Theme.of(context)
                        .copyWith(dividerColor: Colors.transparent),
                    child: ExpansionTile(
                        title: Text(
                          Questions[index],
                          // "Q1: What is Madadguru NGO's mission?",
                          style: GoogleFonts.roboto(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 15, right: 15, bottom: 15),
                            child: Text(Answers[index],
                              // "Madadguru NGO's mission is to empower individuals in India by providing comprehensive assistance in legal matters, real estate, property issues, community development, and financial support. The organization is committed to creating a more just and equitable society.",
                              style: GoogleFonts.roboto(
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ]),
                  ),
                );
              },
            ),
            SizedBox(height: 20,),
          ],
        ),
      ),
    );
  }
}
