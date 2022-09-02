// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:async';
import 'dart:math';

import 'package:camera/camera.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late CameraController camController;
  late dynamic preview = Text("");
  bool complete = false;
  bool darkMode = true;
  bool isEnglish = true;
  int pos = 1;
  bool isCustom = false;

  dynamic posIcons = [
    Icons.vertical_align_center_outlined,
    Icons.vertical_align_bottom_outlined,
    Icons.vertical_align_top_outlined,
  ];
  dynamic posAlignment = [
    Alignment.topCenter,
    Alignment.center,
    Alignment.bottomCenter,
  ];
  dynamic posGradient = [
    [
      Colors.transparent,
      Colors.black.withOpacity(0.4), //! was 0.4
      Colors.black.withOpacity(0.5), //! was 0.4
    ],
    [
      Colors.transparent,
      Colors.black.withOpacity(0.2),
      Colors.transparent,
    ],
    [
      Colors.black.withOpacity(0.5),
      Colors.black.withOpacity(0.4), //! was 0.4
      Colors.transparent,
    ],
  ];

  CameraDescription cameraDescription = CameraDescription(
    name: "1",
    lensDirection: CameraLensDirection.front,
    sensorOrientation: 180,
  );

  List amharicAffirmations = [
    "የወደፊቴን እገነባለሁ።",
    "አእምሮዬን ባደረግኩት ነገር አሸንፋለሁ",
    "በጣም ጥሩ ሰው የሚያደርገኝ ስለታም አእምሮ አለኝ።",
    "እኔ በመሆኔ አመስጋኝ ነኝ እናም ይህ ያሳያል።",
    "እኔ ጎበዝ ሰው ነኝ።",
    "ለራሴ ክብር አለኝ።",
    "ለሰዎች ሁሉ ደግ ነኝ።",
    "መልካም ነገር ልቀበል ይገባኛል።",
    "የአእምሮዬ የመማር እና የማስታወስ ችሎታ በየቀኑ እየጨመረ ነው።",
    "የአሸናፊዎች አስተሳሰብ አለኝ እና ግቦቼን ማሳካት እወዳለሁ።",
    "በየቀኑ የበለጠ በመማር ወደ አዲስ ደረጃዎች እየሄድኩ ነው።",
    "አዎንታዊ ኃይልን አበራለሁ።",
    "እኔ ተሰጥኦ ያለው ሰው ነኝ, እና ማንኛውንም ነገር ማሳካት እችላለሁ።",
    "በሌሎች ሰዎች ሕይወት ላይ አዎንታዊ ተጽእኖ አደርጋለሁ።",
    "ሕይወቴን አፈቅራለሁ!",
    "በየቀኑ የተቻለኝን ለማድረግ እጥራለሁ።",
    "ሕይወትን እቀበላለሁ።",
    "በጣም የተሳካ ሰው ለመሆን በጉዞ ላይ ነኝ።",
    "ሁሉንም ግቦቼን ማሳካት እችላለሁ ምክንያቱም የእኔ እውነተኛ አቅም ገደብ የለሽ ነው።",
    "አእምሮዬ አዲስ መረጃን በበለጠ ፍጥነት ይቀበላል እና ያስኬዳል።",
    "ወደ ሙሉ አቅሜ ለማሳደግ የሚረዳኝን እውቀት ማግኘት እወዳለሁ።",
    "እኔ በጣም ፈጣን ተማሪ ነኝ።",
    "እውቀትን በማግኘት እና በአግባቡ ለመጠቀም በጣም ጎበዝ ነኝ።",
    "የአእምሮዬ የመማር እና የማስታወስ ችሎታ በየቀኑ እየጨመረ ነው።",
    "ሁሉንም ነገር አለማወቅ ምንም አይደለም። ሁልጊዜ መማር እችላለሁ።",
    "አቅም አለኝ!",
    "በሕይወቴ ውስጥ ጤናማ ሚዛን እፈጥራለሁ።",
    "ሁሉንም ነገር ማለፍ እችላለሁ።",
    "ዓለምን መለወጥ እችላለሁ።",
    "ሁሉም ነገር ይቻላል።",
    "አእምሮዬን ማስፋፋቴን እቀጥላለሁ።",
    "የህልሜን ህይወት ከመኖር የሚያግደኝ ምንም ነገር የለም።",
    "እኔ ቆንጆ ሰው ነኝ. አስፈላጊ ነኝ. ጠንካራ ነኝ, እውነተኛ ነኝ።",
    "ሀሳቤን ያደረግኩበትን ማንኛውንም ነገር ማድረግ እችላለሁ።",
    "ራሴን ከሌሎች ጋር የማወዳደርበት ምንም ምክንያት የለኝም።",
    "እኔ ሰው ብቻ ነኝ እና ሁላችንም እንሳሳታለን።",
    "ስኬት የመጨረሻ አይደለም፣ ውድቀትም ለሞት የሚዳርግ አይደለም፣ ለመፅናት መድፈር ነው መጨረሻው ላይ የሚቆጠረው።",
    "ይህን የፈጠርኩትን ህይወት በመኖሬ የተባረኩ ነኝ",
    "በየቀኑ ራሴን በሆነ መንገድ አሻሽላለሁ።",
    "ለጥልቅ ግንኙነቶች ብቁ ነኝ።",
    "እኔ እራሴን እወዳለሁ እና አጸድቃለሁ።",
    "በፈተና ወቅት ሁል ጊዜ እፎይታ ይሰማኛል።",
    "ጥሩ ውጤት ማግኘቴ ለኔ ተፈጥሯዊ ነው።",
    "በማጥናት መደሰትን እየተማርኩ ነው።",
    "መልሱን በምጽፍበት ጊዜ, መረጃን በፍጥነት አስታውሳለሁ።",
    "ፈተናዬን ለማፅዳት በትጋት እና በብልህነት እሰራለሁ።",
    "የፈተናዎቼን ታላቅ ውጤት በጉጉት እጠብቃለሁ።",
    "በአስጨናቂ ሁኔታዎች ውስጥ እንኳን እሳካለሁ።",
    "በፈተና ውስጥ በሚጽፉበት ጊዜ መረጃን ማስታወስ ቀላል ነው።",
    "በደንብ ዝግጁ ስለሆንኩ በዚህ ፈተና ውስጥ ጥሩ እሰራለሁ።",
    "እኔ በጣም ጥሩ ተማሪ ነኝ።",
    "ለዚህ ፈተና ማወቅ ያለብኝን አውቃለሁ።",
    "ስለ ራሴ እና ለፈተና በማደርገው ዝግጅት ጥሩ ስሜት ይሰማኛል።",
    "ፈተናዬን አልፋለሁ።",
    "ሁልጊዜ ትኩረቴን በትምህርቴ ላይ እቆያለሁ።",
    "ጥረቴን ሁሉ ላደርጋቸው በፈለኳቸው ነገሮች ላይ አተኩራለሁ።",
    "በመጀመሪያ አስፈላጊ በሆኑት ተግባራት ላይ አተኩራለሁ።",
    "የማተኮር ችሎታዬ እየጨመረ ነው።",
    "ሁልጊዜ ትኩረቴን በትምህርቴ ላይ እቆያለሁ።",
    "ትልቅ ትኩረት እና ቁርጠኝነት ያለው ተማሪ ነኝ።",
    "ለሥራዬ በእውነት ትኩረት እሰጣለሁ።",
    "በየቀኑ በሁሉም መንገድ በማደርገው ነገር ላይ የበለጠ ትኩረት እሰጣለሁ።",
    "ማተኮር በተፈጥሮ ወደ እኔ ይመጣል።",
    "ሁልጊዜ ትኩረቴ በትምህርቴ ላይ ነው",
    "ሁልጊዜ በትምህርቴ ደስ ይለኛል።",
    "በምማርበት ጊዜ ትኩረቴን እቆያለሁ።",
    "ጥሩ ውጤት ለማግኘት በደንብ አተኩራለሁ።",
    "የሚጠቅመኝን መረጃ ሳገኝ እንደ ስፖንጅ እጠጣዋለሁ!",
    "በአስፈላጊ ነገሮች ላይ አተኩራለሁ፣ እና የቀረውን እለቃለሁ።",
    "ጊዜዬ ዋጋ ያለው ነው።",
    "ከመዘናጋት ነፃ ነኝ።",
    "በትኩረት ማጥናት ወደ እኔ በቀላሉ እና በተፈጥሮ ይመጣል።",
    "እኔ ስኬታማ ነኝ።",
    "እኔ እርግጠኛ ነኝ።",
    "እኔ ኃይለኛ ነኝ።",
    "እኔ ጠንካራ ነኝ።",
    "በየቀኑ እየተሻሻልኩ ነው።",
    "አሁን የሚያስፈልገኝ በውስጤ ነው።",
    "እኔ የማይገታ የተፈጥሮ ኃይል ነኝ።",
    "እኔ ሕያው የስኬት ምሳሌ ነኝ።",
    "የማገኛቸው ሰዎች ላይ አወንታዊ እና አበረታች ተጽእኖ እያሳየሁ ነው።",
    "በሥራዬ ሰዎችን አነሳሳለሁ።",
    "እኔን ከሚያናድዱኝ ወይም ሊያስፈሩኝ ከሚሞክሩት ሀሳቦች በላይ ነኝ።",
    "ዛሬ አስደናቂ ቀን ነው።",
    "በትኩረት ተሞልቻለሁ።",
    "በችግሮቼ አልተገፋሁም፤ በህልሜ ተመርቻለሁ።",
    "በሕይወቴ ውስጥ ስላለኝ ነገር ሁሉ አመስጋኝ ነኝ።",
    "እኔ ራሴን ቻይ ነኝ።",
    "የፈለኩትን መሆን እችላለሁ።",
    "እኔ ያለፈው ህይወቴ አይገልፀኝም በወደፊት ህይወቴ እየተመራሁ ነው።",
    "ዛሬ ውጤታማ ቀን ይሆናል።",
    "እኔ ብልህ ነኝ።",
    "በየቀኑ የበለጠ አመስጋኝ ነኝ።",
    "በየቀኑ ጤናማ እሆናለሁ።",
    "በየቀኑ ግቦቼን ወደ ማሳካት እየተቃረብኩ ነው።",
    "ያለማቋረጥ እያደግኩ እና ወደ ተሻለ ሰው እየቀየርኩ ነው።",
    "ከሁሉም አጥፊ ጥርጣሬዎች እና ፍርሀቶች እራሴን ነጻ አደርጋለው።",
    "እኔ ማንነቴን እራሴን እቀበላለሁ እናም ሰላምን, ሀይልን እና የአእምሮ እና የልብ መተማመንን እፈጥራለሁ።",
    "እኔ ራሴን ይቅር እላለሁ እና ራሴን ነጻ አደርጋለሁ። ይቅር ማለት እና ይቅርታ ይገባኛል።",
    "በየቀኑ እየተፈወስኩ እና እየበረታሁ ነኝ።",
    "ከዚህ በፊት በአስቸጋሪ ጊዜያት ውስጥ አልፌያለው፣ እናም በእነሱ ምክንያት ጠንክሬ እና የተሻለ ሆኜ ወጥቻለሁ።",
    "የሕይወቴን አንድ ቀን አላጠፋም። የእያንዳንዱን ቀን ዋጋ እጨምቃለሁ።",
    "የምፈልገውን ሁሉ ለማሳካት በውስጤ ያለውን አስደናቂ ኃይል ማስታወስ አለብኝ።",
    "በማይጠቅሙ ሀሳቦች ወደ አእምሮዬ ለመግባት ከሚሞክሩ ሰዎች ጋር አልገናኝም።",
    "እኔ በዚህ ዓለም ውስጥ ነኝ፤ ​​ለእኔ እና ለኔ ዋጋ የሚጨነቁ ሰዎች አሉ።",
    "ያለፈው ጊዜዬ አስቀያሚ ሊሆን ይችላል, ግን አሁንም ቆንጆ ነኝ።",
    "ስህተቶችን ሠርቻለሁ፣ ግን እንዲገልጹልኝ አልፈቅድም።",
    "ነፍሴ ከውስጥ ታበራለች እናም የሌሎችን ነፍስ ታሞቃለች።",
    "ራሴን ከሌሎች ጋር አላወዳድርም።",
    "ዋናውን ነገር ጨርሼ የማይሆነውን እተወዋለሁ።",
    "መንፈሴን እመግባለሁ, ሰውነቴን አሠለጥናለሁ። አእምሮዬን አተኩራለሁ። ይህ የእኔ ጊዜ ነው።",
    "ህይወቴ ትርጉም አለው, የማደርገው ነገር ትርጉም አለው። ድርጊቴ ትርጉም ያለው እና የሚያነቃቃ ነው።",
    "ዛሬ ያደረኩት ዛሬ ላደርገው የቻልኩት ምርጥ ነገር ነው። ለዛም አመስጋኝ ነኝ።",
    "ደስታ ምርጫ ነው, እና ዛሬ ደስተኛ ለመሆን እመርጣለሁ።",
    "ግቦችን በቁርጠኝነት እከተላቸዋለሁ።",
    "ችሎታዎቼ ወደሚደነቁኝ ቦታዎች ይወስደኛል።",
    "አእምሮዬን መለወጥ ጥንካሬ እንጂ ድክመት አይደለም።",
    "የእኔን ማንነት እውነት የያዝኩት እኔ ብቻ ነኝ።",
    "የምፈልገውን እንድጠይቅ ተፈቅዶልኛል።",
    "ጥሩ ስሜት እንዲሰማኝ ተፈቅዶልኛል።",
    "በሕይወቴ ውስጥ ስራ እና እረፍትን ማመጣጠን እችላለሁ።",
    "እኔ ሙሉ ነኝ።",
    "እኔ እያደግኩ ነው እናም በራሴ ፍጥነት እሄዳለሁ።",
    "ረክቻለሁ እና ከህመም ነፃ ነኝ።",
    "ደህና ነኝ እና እየተሻልኩ ነው።",
    "ደስተኛ ነኝ።",
    "የተወደድኩ እና የተገባኝ ነኝ።",
    "እኔ ከሁኔታዬ በላይ ነኝ።",
    "ለመፈወስ ክፍት ነኝ።",
    "ዛሬ አዲስ ቀን ስለሆነ ብሩህ ተስፋ አለኝ።",
    "እኔ ሰላማዊ እና ሙሉ ነኝ።",
    "ደህና ነኝ እናም በፍቅር እና ድጋፍ ተከብቤያለሁ።",
    "አሁንም እየተማርኩ ነው ስለዚህ ስህተት መሥራት ምንም ችግር የለውም።",
    "የእኔ አመለካከት አስፈላጊ ነው።",
    "እኔ ዋጋ ያለው እና አጋዥ ነኝ።",
    "ሁለት ተቃራኒ ስሜቶችን በአንድ ጊዜ መያዝ እችላለሁ፣ ይህ ማለት እያሰብኩ ነው ማለት ነው።",
    "በሌሎች እና በራሴ ውስጥ ያሉትን መልካም ባሕርያት አከብራለሁ።",
    "ሁሉንም ነገር በፍቅር አደርጋለሁ።",
    "በጨለማ ቦታዎች ውስጥ መቆየት የለብኝም, እዚህ ለእኔ እርዳታ አለ።",
    "እኔ ከማንነቴ በቀር ሌላ ማንንም አላስመስልም።",
    "ወደ ፍላጎቶቼ አደግኩ።",
    "ከማስበው በላይ መጥቻለሁ፣ እና በመንገዱ እየተማርኩ ነው።",
    "ለመሳካት የሚያስፈልገኝ ነገር ሁሉ አለኝ።",
    "ጥበብን እና ሙዚቃን ወደ ህይወቴ እጋብዛለሁ።",
    "ከእውቀት በላይ ጥበብን እይዛለሁ።",
  ];

  List englishAffirmations = [
    "My mind's ability to learn and remember is increasing every day.",
    "I have a sharp mind which makes me a very good person.",
    "I have a winner's mindset and I love accomplishing my goals.",
    "I am advancing to new levels by learning more each day.",
    "I feel thankful to be me and it shows.",
    "I radiate positive energy.",
    "I am a gifted person, and I can achieve anything.",
    "I am a talented and prominent person.",
    "I have self-respect and dignity.",
    "I make a positive impact on other people' lives.",
    "I am kind and courteous to all people.",
    "I love my life!",
    "I strive to do my best every day.",
    "I embrace life.",
    "I am on the journey of becoming a very successful person.",
    "It is possible for me to achieve all my goals because my true potential is limitless.",
    "My mind absorbs and processes new information with greater speed.",
    "I love gaining knowledge which helps me in growing to my full potential.",
    "I am a very quick learner.",
    "I am very good at gaining knowledge and making proper use of it.",
    "My mind's ability to learn and remember is increasing every day.",
    "It's okay not to know everything. I can always learn.",
    "I am capable.",
    "I am in control of my progress.",
    "I create a healthy balance in my life.",
    "I can get through everything.",
    "I am building my future.",
    "I can change the world.",
    "I will win at what I put my mind to.",
    "I am excited to step into a new world.",
    "Anything is possible.",
    "I will continue to expand my mind.",
    "I am worthy to receive.",
    "Nothing can stop me from living the life of my dreams.",
    "I am a beautiful person. I matter. I am strong. I am genuine. ",
    "I can do anything I put my mind to. I've got this.",
    "There is no reason for me to compare myself to others.",
    "I'm only human and we all make mistakes.",
    "Success is not final, and failure is not fatal. It's the courage to persevere that counts in the end.",
    "I am blessed to live this life that I have created.",
    "Every day, I improve myself in some way.",
    "I am worthy of deep connections.",
    "I love and approve of myself.",
    "I am always relaxed during exams.",
    "Getting good grades is natural for me.",
    "I am learning to enjoy studying.",
    "While writing answers, I recall information quickly.",
    "I work both hard and smartly to clear my exams.",
    "I look forward to a great result of my exams.",
    "I succeed even in stressful situations.",
    "Recalling information while writing in exams is easy.",
    "I am good at turning my nervous feelings into high confidence.",
    "I will do well in this exam as I am well prepared.",
    "I am an excellent student.",
    "I know what I need to know for this exam.",
    "I feel good about myself and my preparations for tests and exams.",
    "I will pass my exams.",
    "I always stay focused on my studies.",
    "I concentrate all my efforts on the things I want to accomplish.",
    "I focus on the important tasks first.",
    "I focus on one task at a time.",
    "My ability to focus is increasing which is making me a peak performer.",
    "I always stay focused on my studies.",
    "I am recognized as a student with immense focus and determination.",
    "I am truly attentive to my work.",
    "Every day in every way I am becoming more focused on what I do.",
    "Focusing comes naturally to me.",
    "I always stay focused on my studies",
    "I always enjoy my studies.",
    "I stay focused while studying for exams.",
    "I focus well to get good grades.",
    "When I am exposed to information that benefits me, I absorb it like a sponge!",
    "I will focus on the important things, and let the rest go.",
    "My time is valuable.",
    "I am free of distractions.",
    "Studying with focus comes easily and naturally to me.",
    "I am successful.",
    "I am confident.",
    "I am powerful.",
    "I am strong.",
    "I am getting better and better every day.",
    "All I need is within me right now.",
    "I wake up motivated.",
    "I am an unstoppable force of nature.",
    "I am a living, breathing example of motivation.",
    "I am living with abundance.",
    "I am having a positive and inspiring impact on the people I come into contact with.",
    "I am inspiring people through my work.",
    "I'm rising above the thoughts that are trying to make me angry or afraid.",
    "Today is a phenomenal day.",
    "I am turning DOWN the volume of negativity in my life, while simultaneously turning UP the volume of positivity.",
    "I am filled with focus.",
    "I am not pushed by my problems; I am led by my dreams.",
    "I am grateful for everything I have in my life.",
    "I am independent and self-sufficient.",
    "I can be whatever I want to be.",
    "I am not defined my by past; I am driven by my future.",
    "I use obstacles to motivate me to learn and grow.",
    "Today will be a productive day.",
    "I am intelligent and focused.",
    "I feel more grateful each day.",
    "I am getting healthier every day.",
    "Each and every day, I am getting closer to achieving my goals.",
    "I am constantly growing and evolving into a better person.",
    "I'm freeing myself from all destructive doubt and fear.",
    "I accept myself for who I am and create peace, power and confidence of mind and of heart.",
    "I am going to forgive myself and free myself. I deserve to forgive and be forgiven.",
    "I am healing and strengthening every day.",
    "I've made it through hard times before, and I've come out stronger and better because of them. I'm going to make it through this.",
    "I do not waste away a single day of my life. I squeeze every ounce of value out of my days.",
    "I must remember the incredible power I possess within me to achieve anything I desire.",
    "I do not engage with people who try to penetrate my mind with unhelpful thoughts.",
    "I belong in this world; there are people that care about me and my worth.",
    "My past might be ugly, but I am still beautiful.",
    "I have made mistakes, but I will not let them define me.",
    "My soul radiates from the inside and warms the souls of others.",
    "I don't compare myself to others.",
    "I am going to make myself so proud.",
    "I finish what matters and let go of what does not.",
    "I feed my spirit. I train my body. I focus my mind. This is my time.",
    "My life has meaning. What I do has meaning. My actions are meaningful and inspiring.",
    "What I have done today was the best I was able to do today. And for that, I am thankful.",
    "Happiness is a choice, and today I choose to be happy.",
    "I set goals and go after them with all the determination I can muster.",
    "My own skills and talents will take me to places that amaze me.",
    "Changing my mind is a strength, not a weakness.",
    "I affirm and encourage others, as I do myself.",
    "I alone hold the truth of who I am.",
    "I am allowed to ask for what I want and what I need.",
    "I am allowed to feel good.",
    "I am capable of balancing ease and effort in my life.",
    "I am complete as I am, others simply support me.",
    "I am growing and I am going at my own pace. ",
    "I am content and free from pain.",
    "I am good and getting better.",
    "I am held and supported by those who love me.",
    "I am in charge of how I feel and I choose to feel happy.",
    "I am loved and worthy.",
    "I am more than my circumstances dictate.",
    "I am open to healing.",
    "I am optimistic because today is a new day.",
    "I am peaceful and whole.",
    "I am safe and surrounded by love and support.",
    "I am still learning so it's okay to make mistakes.",
    "My perspective is important.",
    "I am valued and helpful.",
    "I belong here, and I deserve to take up space.",
    "I can be soft in my heart and firm in my boundaries.",
    "I can hold two opposing feelings at once, it means I am processing.",
    "I celebrate the good qualities in others and myself.",
    "I do all things in love.",
    "I do not have to linger in dark places; there is help for me here.",
    "I do not pretend to be anyone or anything other than who I am.",
    "I do not rise and fall for another.",
    "I do not rush through my life.",
    "I grow towards my interests.",
    "I have come farther than I would have ever thought possible, and I'm learning along the way.",
    "I have everything I need to succeed.",
    "I invite art and music into my life.",
    "I hold wisdom beyond knowledge.",
    "I invite abundance and a generous heart.",
  ];

  List customAffirmations = ["You don't have any custom affirmations"];

  int curIndex = 0;

  void loadSettings() async {
    dynamic settingsBox = await Hive.openBox("settings");
    darkMode = await settingsBox.get("darkMode");
    isEnglish = await settingsBox.get("isEnglish");
    isCustom = await settingsBox.get("isCustom");
    pos = await settingsBox.get("textPosition");
    dynamic customAffirmationsBox = await Hive.openBox("customAffirmationsBox");
    dynamic customAffirmationsResults =
        await customAffirmationsBox.get("customAffirmations");
    if (customAffirmationsResults == null) {
      customAffirmations = ["You don't have any custom affirmations"];
    } else {
      customAffirmations = customAffirmationsResults;
    }
    setAffirmationIndex();
  }

  void saveSettings() async {
    dynamic settingsBox = await Hive.openBox("settings");
    await settingsBox.put("darkMode", darkMode);
    await settingsBox.put("isEnglish", isEnglish);
    await settingsBox.put("textPosition", pos);
    await settingsBox.put("isCustom", isCustom);
  }

  void timedChange() {
    Timer.periodic(Duration(seconds: 20), (value) {
      setAffirmationIndex();
      setState(() {});
    });
  }

  ConfettiController controllerCenter =
      ConfettiController(duration: const Duration(seconds: 3));

  Future initCam() async {
    complete = false;
    setState(() {});
    await camController.initialize();
    preview = camController.buildPreview();
    Timer(
      Duration(seconds: 2),
      () {
        setAffirmationIndex();
        complete = true;
        timedChange();
        setState(() {});
      },
    );
  }

  void setAffirmationIndex() {
    if (isCustom == true) {
      if (customAffirmations.length > 1) {
        curIndex = Random().nextInt(customAffirmations.length);
      } else {
        curIndex = 0;
      }
    } else {
      if (isEnglish == true) {
        curIndex = Random().nextInt(englishAffirmations.length);
      } else {
        curIndex = Random().nextInt(amharicAffirmations.length);
      }
    }
    setState(() {});
  }

  Future addAffirmation() async {
    Box customAffirmationsBox = await Hive.openBox("customAffirmationsBox");
    dynamic customAffirmationsResult =
        await customAffirmationsBox.get("customAffirmations");
    if (customAffirmationsResult == null) {
      customAffirmations = [];
    } else {
      customAffirmations = customAffirmationsResult;
    }
    customAffirmations.add(newAffirmationController.text.toString().trim());
    await customAffirmationsBox.put("customAffirmations", customAffirmations);
    newAffirmationController.clear();
    setAffirmationIndex();
    setState(() {});
  }

  Future clearCustomAffirmations() async {
    Box customAffirmationsBox = await Hive.openBox("customAffirmationsBox");
    dynamic customAffirmationsResult =
        await customAffirmationsBox.get("customAffirmations");
    customAffirmationsBox.clear();
    customAffirmations = ["You don't have any custom affirmations"];
    setAffirmationIndex();
    setState(() {});
  }

  TextEditingController newAffirmationController = TextEditingController();
  void addNewAffirmation() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      anchorPoint: Offset(0, 100),
      constraints:
          BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.7),
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.9,
          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
          decoration: BoxDecoration(
            color: darkMode == true ? Colors.black : Colors.grey[200],
            borderRadius: BorderRadius.all(
              Radius.circular(20.0),
            ),
          ),
          child: Column(
            children: [
              Text(
                "Add Custom Affirmation",
                style: TextStyle(
                  color: darkMode == true ? Colors.grey[200] : Colors.grey[900],
                  fontSize: 20.0,
                  // fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
                margin: EdgeInsets.symmetric(horizontal: 5.0, vertical: 15.0),
                decoration: BoxDecoration(
                    color: darkMode == true ? Colors.black : Colors.grey[200],
                    borderRadius: BorderRadius.all(
                      Radius.circular(20.0),
                    ),
                    border: Border.all(
                      color: (darkMode == true
                          ? Colors.grey[500]!
                          : Colors.grey[900]!),
                    )),
                child: TextField(
                  controller: newAffirmationController,
                  style: TextStyle(
                    color:
                        darkMode == true ? Colors.grey[200] : Colors.grey[900],
                  ),
                  decoration: InputDecoration(
                    hintText: "enter affirmation",
                    hintStyle: TextStyle(
                      color: darkMode == true
                          ? Colors.grey[200]
                          : Colors.grey[900],
                      // fontSize: 20.0,
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    Colors.lightBlueAccent,
                  ),
                  fixedSize: MaterialStateProperty.all(
                    Size(200.0, 40.0),
                  ),
                ),
                onPressed: () async {
                  await addAffirmation();
                },
                child: Text(
                  "Add Affirmation",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.0,
                  ),
                ),
              ),
              Spacer(),
              Text(
                "You have ${customAffirmations.length.toString()} custom affirmations.",
                style: TextStyle(
                  color: darkMode == true ? Colors.grey[200] : Colors.grey[900],
                  fontSize: 14.0,
                  // fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10.0),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    Colors.redAccent,
                  ),
                  fixedSize: MaterialStateProperty.all(
                    Size(200.0, 40.0),
                  ),
                ),
                onPressed: () async {
                  await clearCustomAffirmations();
                },
                child: Text(
                  "Clear Affirmations",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.0,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void initState() {
    loadSettings();
    // TODO: implement initState
    super.initState();
    camController = CameraController(
      cameraDescription,
      ResolutionPreset.max,
      enableAudio: false,
    );
    initCam();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    camController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return complete == false
        ? Scaffold(
            backgroundColor: Colors.black,
            appBar: AppBar(
              backgroundColor: Colors.black,
            ),
            body: ListView(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 100.0),
                    Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Image.asset("assets/icon.png"),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 40.0),
                          child: Column(
                            children: [
                              Text(
                                "Good Mirror",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.grey[200],
                                  fontSize: 22.0,
                                ),
                              ),
                              SizedBox(height: 10.0),
                              Text(
                                "This mirror sees through you!",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.grey[400],
                                  fontSize: 15.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 150.0),
                    Text(
                      "Made with  🤍  by Dream Intelligence\n\n Augest 2022",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 12.0,
                      ),
                    ),
                  ],
                ),
              ],
            ))
        : Scaffold(
            backgroundColor: darkMode == true ? Colors.black : Colors.grey[200],
            appBar: AppBar(
              backgroundColor:
                  darkMode == true ? Colors.black : Colors.grey[200],
              elevation: 0.0,
              leading: TextButton(
                child: Text(
                  isEnglish == true ? "ሀለሐ" : "ABC",
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.grey[600],
                  ),
                ),
                onPressed: () {
                  isEnglish = !isEnglish;
                  saveSettings();
                  setAffirmationIndex();
                },
              ),
              actions: [
                IconButton(
                  onPressed: () async {
                    await initCam();
                  },
                  icon: Icon(
                    Icons.refresh,
                    color: Colors.grey[600],
                  ),
                ),
                IconButton(
                  onPressed: () {
                    isCustom = !isCustom;
                    saveSettings();
                    setAffirmationIndex();
                    setState(() {});
                  },
                  icon: Icon(
                    isCustom == true
                        ? Icons.phone_iphone_outlined
                        : Icons.person_outline_sharp,
                    color: Colors.grey[600],
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    // await initCam();
                    pos++;
                    if (pos > 3) {
                      pos = 1;
                    }
                    saveSettings();
                    setState(() {});
                  },
                  icon: Icon(
                    posIcons[pos - 1],
                    color: Colors.grey[600],
                  ),
                ),
                IconButton(
                  onPressed: () {
                    darkMode = !darkMode;
                    saveSettings();
                    setState(() {});
                  },
                  icon: Icon(
                    darkMode == true
                        ? Icons.light_mode_outlined
                        : Icons.dark_mode_outlined,
                    color: Colors.grey[600],
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    // await initCam();
                    addNewAffirmation();
                  },
                  icon: Icon(
                    Icons.add,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            body: ListView(
              children: [
                Column(
                  children: [
                    Stack(
                      alignment: posAlignment[pos - 1],
                      children: [
                        Container(
                          child: CameraPreview(
                            camController,
                            child: preview,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(
                            // bottom: 20.0,
                            left: 10.0,
                            right: 10.0,
                          ),
                          width: double.infinity,
                          height: 130.0,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            // color: Colors.black.withOpacity(0.1),
                            gradient: LinearGradient(
                              colors: posGradient[pos - 1],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                            ),
                          ),
                          child: GestureDetector(
                            onTap: () {
                              setAffirmationIndex();
                            },
                            child: Text(
                              isCustom == true
                                  ? customAffirmations[curIndex]
                                  : isEnglish == true
                                      ? englishAffirmations[curIndex]
                                      : amharicAffirmations[curIndex],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.grey[200],
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0, //! was 18.0
                              ),
                            ),
                          ),
                        ),
                        ConfettiWidget(
                          confettiController: controllerCenter,
                          blastDirectionality: BlastDirectionality.explosive,
                          shouldLoop: false,
                          numberOfParticles: 50,
                          gravity: 0.4,
                          colors: const [
                            Colors.green,
                            Colors.blue,
                            Colors.pink,
                            Colors.orange,
                            Colors.purple
                          ],
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          controllerCenter.play();
                          print("here");
                        },
                        child: Text(
                          "You look beautiful",
                          style: TextStyle(
                            color: darkMode == true
                                ? Colors.grey[800]!
                                : Colors.grey[500],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
  }
}
