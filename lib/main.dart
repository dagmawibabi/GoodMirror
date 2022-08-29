// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:math';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late CameraController camController;
  late dynamic preview = Text("");
  bool complete = false;
  bool darkMode = true;
  bool isEnglish = true;
  int pos = 1;

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
      Colors.black.withOpacity(0.9), //! was 0.4
    ],
    [
      Colors.transparent,
      Colors.black.withOpacity(0.2),
      Colors.transparent,
    ],
    [
      Colors.black.withOpacity(0.4),
      Colors.transparent,
    ],
  ];

  CameraDescription cameraDescription = CameraDescription(
    name: "1",
    lensDirection: CameraLensDirection.front,
    sensorOrientation: 180,
  );

  Future initCam() async {
    textIndex = 0;
    await camController.initialize();
    preview = camController.buildPreview();
    complete = true;
    setState(() {});
  }

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
  ];

  //!
  List medhanitTexts = [
    "Hey Med 👋",
    "My baby 😍",
    "I made this little thing for you.",
    "It's nothing more than a mirror and my words...\n🪞",
    "But I got a lot to say to you.",
    "See this person in this mirror?",
    "Just look at you!",
    "There are no filters, no editting, no nothing...",
    "but look at your beautiful skin...",
    "...gorgeous big eyes... \n👁👁",
    "...lips I wish I can kiss right now...\n👄",
    "and smile esti\n😊",
    "God, your smile fucking lights up my day ewnet!",
    "and ughh those beautiful pearly teeth!!! \n😁",
    "How r they so white??! 😍",
    "I mean c'mon u look like someone designed u in a computer!",
    "Okay enough about your physical beauty!",
    "See this mirror isn't like the one's you've seen before!\n It sees beyond that! ✨",
    "So let me get to my point",
    "I know you're not going thru the best of times lately...\n😟",
    "and I know you're beating yourself up...\n😣",
    "but baby I just wanna tell you that...",
    "YOU, are the best thing I've ever had the chance of meeting!\n💙",
    "I'm so glad that I called the wrong number to find the right person on that holiday years ago! 📞",
    "To this day I can feel the shock I felt when you told me that you were Medhanit 🤯",
    "Baby... ",
    "trust in what I'm about to say...",
    "...take a deep breath...\n😮‍💨",
    "...don't doubt anything...\n😊",
    "let every word sink deep into your heart! 🫀",
    "Med...",
    "YOU ARE GOING TO BE AN INCREDIBLE ARCHITECT! 🏰",
    "YOU ARE ON THE RIGHT PATH! 🛣",
    "YOU RADIATE POSITIVE ENERGY! ⚡️",
    "YOUR MIND IS LIMITLESS! ♾",
    "YOUR SOUL RADIATES HEAT AND WARMS OTHER PEOPLE! \n❤️",
    "I know you believe in aura's and all that crazy people stuff...\n😅",
    "So I'll tell you in the language uk...",
    "You are made of magic! 🪄\n My aura is in perfect harmony with yours! 💫",
    "Miles apart gin sint gize new we feel eachother's emotions?",
    "or accidentally talk about something that's both in our minds?",
    "sinte new 'Our Connection eko' eyaln yeminigorirew??",
    "It's like I've always said, We are one person living in two bodies! 👩‍❤️‍👨",
    "Baby ik u r trying to be perfect for me",
    "But know that the perfect Medhanit, isn't the one that you'll be making in the future...",
    "It's the one that's here with me right now that wants to give me the perfect version of herself. 😘",
    "You, as you are staring in this mirror...",
    "YOU, are my perfect girlfriend!",
    "You are the only person \nI found home in! 🏡",
    "Not the person you want to be, or the perfect version you want for me...",
    "BUT THIS PERSON IN THIS MIRROR...",
    "THIS PERSON IS THE ONE I FOUND HOME IN!",
    "With all the imperfections you see and all the mistakes you've done...",
    "YOU ARE THE ONLY PERSON I FOUND HOME IN!! 🏡❤️",
    "And in my world that means ALOT BABY!!",
    "So this person in this mirror...\n (Look in the mirror)",
    "I love her with all my heart, body and mind! 🌈",
    "All your perfect imperfections endale I am proud to show off to the world and be proud of! 🥳",
    "This person you are staring at, \n(look at yourself)",
    "I swear to God, if it comes to it I will die for you ewnet. 🖤",
    "Cause in my mind life without you isn't a life I want to live.",
    "So yene konjo, manm baynorlsh, manm tiru neger baylsh, friends bitachi, or lonely bisemash...",
    "ene behiwet eskalehu dires yemiwedsh ena yeminafksh sew endale eweki",
    "kazam alfo ken beken 'abragn bitihon' eyale yemimegn sew endale eweki",
    "kezam alfo degmo beserashiw neger hulu yemikora ena yemideset and all your tiny or big accomplishments celebrate yemiaderg sew endalesh eweki",
    "and ya sew ene negn baby!",
    "Feeling loved or not 🥰",
    "We're talking lots or not 🤣",
    "Abreshgn honsh or not 😔",
    "We're arguing or not 😡",
    "Through it all kelibe new miwedsh I swear to God. Libe eskifeneda new miwedsh, yenefse fikir nesh! 💚",
    "Just one last time stare at your self in this mirror",
    "This mirror is beautiful, cause the mirror to the beautiful is beautiful!",
    "So the next time you walk by your reflection remember all that I just said and smile! 😊",
    "Cause you get to be this beautiful person in all your reflections!",
    "Your words are my cozy fireplace, your breath is my wine. You are everything to me. 🌎",
    "It's lelit 10 seat as i'm making this for you and silanchi eyasebku silehone chelemaw tefto lelite tsehay new ☀️",
    "And I'm glad I get to be your mirror today, cause never have I ever reflected any soul as dreamy as yours! 💝",
    "Have a beautiful day baby! 💐",
    "I love you! \n🌧🌧🌧",
    "- Here lies the reflection of the most beautiful soul - \n👇",
    " ",
  ];
  int textIndex = 0;
  //!

  @override
  void initState() {
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
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent, //Colors.grey[200],
        statusBarIconBrightness: Brightness.dark,
      ),
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: darkMode == true ? Colors.black : Colors.grey[200],
        appBar: AppBar(
          backgroundColor: darkMode == true ? Colors.black : Colors.grey[200],
          elevation: 0.0,
          //   leading: TextButton(
          //     child: Text(
          //       isEnglish == true ? "ሀለሐ" : "ABC",
          //       style: TextStyle(
          //         fontSize: 14.0,
          //         color: Colors.grey[600],
          //       ),
          //     ),
          //     onPressed: () {
          //       isEnglish = !isEnglish;
          //       setState(() {});
          //     },
          //   ),
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
              onPressed: () async {
                // await initCam();
                pos++;
                if (pos > 3) {
                  pos = 1;
                }
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
                setState(() {});
              },
              icon: Icon(
                darkMode == true
                    ? Icons.light_mode_outlined
                    : Icons.dark_mode_outlined,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        body: ListView(
          children: [
            complete == false
                ? Text("")
                : Stack(
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
                        height: 130.0, //! was 130.0
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
                            //!
                            textIndex++;
                            if (textIndex >= medhanitTexts.length) {
                              textIndex = 0;
                            }
                            //!
                            setState(() {});
                          },
                          child: Text(
                            //!
                            medhanitTexts[textIndex],
                            //!
                            // isEnglish == true
                            //     ? englishAffirmations[Random()
                            //         .nextInt(englishAffirmations.length - 1)]
                            //     : amharicAffirmations[Random()
                            //         .nextInt(amharicAffirmations.length - 1)],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.grey[200],
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0, //! was 18.0
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
          ],
        ),
        //!
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              // mini: true,
              backgroundColor:
                  darkMode == true ? Colors.grey[900]! : Colors.grey[300]!,
              child: Icon(
                Icons.navigate_before_outlined,
                color: darkMode == true ? Colors.grey[200] : Colors.black,
              ),
              onPressed: () {
                textIndex--;
                if (textIndex <= -1) {
                  textIndex = medhanitTexts.length - 1;
                }
                setState(() {});
              },
            ),
            SizedBox(width: 10.0),
            FloatingActionButton(
              // mini: true,
              backgroundColor:
                  darkMode == true ? Colors.grey[900]! : Colors.grey[300]!,
              child: Icon(
                Icons.navigate_next_outlined,
                color: darkMode == true ? Colors.grey[200] : Colors.black,
              ),
              onPressed: () {
                textIndex++;
                if (textIndex >= medhanitTexts.length) {
                  textIndex = 0;
                }
                setState(() {});
              },
            ),
          ],
        ),
        //!
      ),
    );
  }
}
