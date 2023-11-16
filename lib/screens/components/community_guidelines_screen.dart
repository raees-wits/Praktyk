// community_guidelines_screen.dart
import 'package:flutter/material.dart';

class CommunityGuidelinesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          title: Text('Community Guidelines'),
          backgroundColor: Colors.grey, // Setting the app bar color to grey
          bottom: TabBar(
            tabs: [
              Tab(text: 'Afrikaans'),
              Tab(text: 'English'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildGuidelinesText(_afrikaansGuidelines()), // Afrikaans guidelines
            _buildGuidelinesText(_englishGuidelines()),   // English guidelines
          ],
        ),
      ),
    );
  }

  Widget _buildGuidelinesText(String guidelinesText) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Text(
        guidelinesText,
        style: TextStyle(fontSize: 16.0),
      ),
    );
  }

  String _afrikaansGuidelines() {
    return '''
Community Guidelines for Praktyk - Afrikaanse Gemeenskap
   
Welkom by Praktyk! Ons is verheug om jou in ons Afrikaanse leer- en oefengemeenskap te verwelkom. 
Om 'n positiewe, respekvolle, en ondersteunende omgewing vir almal te verseker, vra ons dat alle lede hierdie riglyne volg:

Respek en Hoffelijkheid: Behandel elke gemeenskapslid met respek. Geen beledigende, neerhalende, of haatspraak sal geduld word nie.

Positiewe Bydraes: Moedig mekaar aan en bied hulp waar jy kan. Ons is hier om van mekaar te leer en te groei in ons kennis van Afrikaans.

Veiligheid en Privaatheid: Deel geen persoonlike inligting van jouself of ander lede sonder hul uitdruklike toestemming nie.

Kulturele Sensitiwiteit: Wees bewus van die ryk verskeidenheid en kulturele agtergronde in ons gemeenskap. Vermy stereotipes en kultureel ongevoelige 
opmerkings.

Eerlikheid en Oorspronklikheid: Bied oorspronklike bydraes en vermy plagiaat. Gee erkenning waar dit verskuldig is.

Moderasie: Moenie spam, irrelevant advertensies of herhaaldelike boodskappe plaas nie. Fokus op relevante en konstruktiewe besprekings.

Volg die Wet: Moenie aktiwiteite bevorder of deelneem aan enigiets wat onwettig of skadelik is nie.

Taalgebruik: Alhoewel ons fokus op Afrikaans, verwelkom ons lede van alle taalagtergronde. Wees geduldig en ondersteunend met lede wat nuut is tot die 
Afrikaanse taal.

Rapportering van Oortredings: Indien jy enige oortredings van hierdie riglyne gewaar, rapporteer dit asseblief aan die moderators.

Positiewe Ervaring: Ons streef daarna om Praktyk 'n plek te maak waar elkeen gemaklik kan leer en groei. Laat ons saamwerk om 'n ondersteunende omgewing te 
skep.


Onthou: Hierdie gemeenskap is wat ons daarvan maak! Laat ons elke interaksie 'n geleentheid maak om te leer, te deel, en respek te betoon.
    ''';
  }

  String _englishGuidelines() {
    return '''
Welcome to Praktyk! We're delighted to have you in our Afrikaans learning and practice community. 

To ensure a positive, respectful, and supportive environment for everyone, we ask all members to adhere to these guidelines:

Respect and Courtesy: Treat every community member with respect. No abusive, demeaning, or hate speech will be tolerated.

Positive Contributions: Encourage each other and offer help where you can. We are here to learn from each other and grow in our knowledge of Afrikaans.

Safety and Privacy: Do not share any personal information about yourself or other members without their explicit consent.

Cultural Sensitivity: Be aware of the rich diversity and cultural backgrounds in our community. Avoid stereotypes and culturally insensitive remarks.

Honesty and Originality: Provide original contributions and avoid plagiarism. Give credit where it is due.

Moderation: Do not post spam, irrelevant advertisements, or repetitive messages. Focus on relevant and constructive discussions.

Obey the Law: Do not promote or participate in any activities that are illegal or harmful.

Language Use: Although we focus on Afrikaans, we welcome members from all language backgrounds. Be patient and supportive of members who are new to the Afrikaans language.

Reporting Violations: If you notice any violations of these guidelines, please report them to the moderators.

Positive Experience: We strive to make Praktyk a place where everyone can comfortably learn and grow. Let's work together to create a supportive environment.

Remember: This community is what we make of it! Let's make every interaction an opportunity to learn, share, and show respect.
    ''';
  }
}
