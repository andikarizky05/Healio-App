import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/localization_service.dart';

class HealthInfoDetailScreen extends StatelessWidget {
  final Map<String, String> healthInfo;

  const HealthInfoDetailScreen({
    super.key,
    required this.healthInfo,
  });

  @override
  Widget build(BuildContext context) {
    final localizationService = Provider.of<LocalizationService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          healthInfo['title'] ?? '',
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _getIconForTitle(healthInfo['title'] ?? ''),
                  size: 64,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                healthInfo['title'] ?? '',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                healthInfo['date'] ?? DateTime.now().toString().substring(0, 10),
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                _getFullContent(healthInfo['title'] ?? ''),
                style: const TextStyle(
                  fontSize: 16,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 24),
              if (healthInfo['source'] != null)
                Text(
                  '${localizationService.translate("source")}: ${healthInfo['source']}',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getIconForTitle(String title) {
    if (title.contains('COVID')) {
      return Icons.coronavirus;
    } else if (title.contains('Mental')) {
      return Icons.psychology;
    } else {
      return Icons.health_and_safety;
    }
  }

  String _getFullContent(String title) {
    switch (title) {
      case 'Gaya Hidup Sehat':
        return '''
Gaya hidup sehat adalah sebuah komitmen jangka panjang untuk menjaga atau melakukan beberapa hal agar mampu mendukung fungsi tubuh, sehingga berdampak baik bagi kesehatan. Agar dapat mewujudkannya, ada beberapa upaya yang bisa dilakukan untuk menerapkan pola hidup sehat. Contohnya seperti  menjaga asupan makanan sehat dengan diet dan nutrisi, berolahraga, melakukan kegiatan positif untuk menghindari stres, dan masih banyak lagi. Beberapa hal tersebut tentunya dapat meningkatkan kualitas hidup sekaligus membawa pengaruh positif bagi lingkungan. 

Langkah-Langkah yang dapat dilakukan untuk memulai gaya hidup sehat
1.  Makan Makanan yang Bergizi 
    Sejak kecil kita sudah dikenalkan dengan pola makan 4 sehat 5 sempurna. Jadi, pastikan tubuh kamu kamu selalu menerima asupan nutrisi yang seimbang. Kamu bisa konsumsi daging, susu, telur, atau ikan untuk sumber protein, dan karbohidrat dari nasi, kentang, oat, atau roti gandum untuk memberikan kamu energi. Jangan lupa selalu konsumsi buah dan sayur yang mengandung serat probiotik, vitamin, mineral, serta berbagai antioksidan.
2.  Olahraga Rutin
    Selain makan makanan yang bergizi, kamu juga perlu rutin olahraga agar tubuh tetap aktif, sehat, ideal, dan bugar. Olahraga juga dapat mencegah berbagai macam penyakit dan mengurangi stres. Biasakan luangkan waktu setiap harinya selama 20-30 menit untuk menggerakan tubuhmu. Tak perlu yang berat, kamu bisa hanya berjalan kaki atau pilih jenis olahraga lainnya yang kamu sukai.
3.  Perbanyak Minum Air Putih
    Boba dan kopi-kopi kekinian memang selalu membuat kita tergoda. Tapi, jangan lupa untuk perhatikan asupan air putih juga, karena dengan tercukupinya air dalam tubuh, fungsi organ kita pun akan bekerja secara maksimal. Sesuaikan kebutuhan cairan ini dengan berat tubuh dan intensitas kegiatan kamu. Jika kamu banyak beraktivitas, tentunya kamu perlu mengonsumsi air putih lebih banyak.
4.  Kelola Tidur dengan Baik
    Jangan pernah meremehkan tidur, karena manfaatnya sangat besar bagi tubuh kamu. Tidur jadi kunci dari kekebalan tubuh yang kuat, meningkatkan daya ingat, dan bisa menjadi pengendali nafsu makan. Untuk orang dewasa, kamu perlu tidur minimal 8 jam setiap hari. Orang yang tidurnya kurang dari 6 jam setiap malam akan 4 kali lebih mudah mengalami flu, dibandingkan yang tidurnya cukup. Jadi, mulai pertimbangkan kembali pengelolaan tidurmu dengan baik ya.
5.  Mengelola Stres
    Empat kegiatan di atas sudah kamu lakukan dengan baik dan rutin, namun kamu masih sering pusing dan banyak pikiran? Hati-hati, stres malah membuatmu mudah terserang penyakit. Stres sudah terbukti dapat mengganggu sistem imun tubuh. Orang yang stres dapat melepas dan mengurangi kemampuan hormon kortisol yang bisa melawan peradangan dan penyakit.
''';

      case 'Pentingnya Menjaga Kesehatan Mental':
        return '''
Kesehatan mental sama pentingnya dengan kesehatan tubuh. Sebab, jiwa yang sehat tentu bisa membuat seseorang menjadi lebih produktif. Bahkan, kesehatan mental juga bisa mempengaruhi kesehatan fisik loh. Kebanyakan dari  orang yang punya optimisme memiliki jantung yang lebih sehat dan bahkan dapat menurunkan laju perkembangan penyakit. Faktor-faktor lain, seperti kepuasan hidup dan kebahagiaan, dikaitkan dengan penurunan risiko penyakit kardiovaskular terlepas dari faktor-faktor seperti usia seseorang, status sosial ekonomi, status merokok, atau berat badan. Jadi, sudah saatnya bagi Anda untuk mengetahui pentingnya menjaga kesehatan mental.

Apa pentingnya menjaga kesehatan mental?
Dalam setiap tahap kehidupan, kesehatan mental penting untuk terus dijaga, mulai dari masa kanak-kanak, remaja, hingga dewasa. Menjaga kesehatan mental sangat penting untuk menstabilkan perilaku, emosi, dan pikiran. 
Berikut beberapa manfaat pentingnya menjaga kesehatan mental:
A. Memperbaiki suasana hati
B. Mengurangi kecemasan
C. Merasa lebih damai
D. Berpikir lebih jernih
E. Meningkatkan hubungan, baik dengan diri sendiri maupun orang lain
F. Meningkatkan harga diri

Cara menjaga kesehatan mental:
1.  Menghargai diri sendiri
    Menghargai diri sendiri berarti menghargai kesejahteraan dan kebahagiaan Anda secara keseluruhan. Saat Anda menghargai diri sendiri, Anda memberikan dukungan tanpa syarat dan kepedulian terhadap diri sendiri. Menghargai diri sendiri bisa dilakukan lewat kesediaan untuk memenuhi kebutuhan pribadi. Kebutuhan ini bentuknya bisa sederhana, seperti makan meskipun sedang tidak ingin makan, mandi meskipun tidak ingin bangun dari tempat tidur, dan sebagainya. Menghargai diri sendiri dianggap sebagai aspek penting dari menjaga kesehatan mental. Sebab, hal ini dikaitkan dengan peningkatan kebahagiaan dan kepuasan hidup yang lebih besar.
2.  Kelola stres
    Tidak semua stres itu buruk. Namun, stres jangka panjang dapat menyebabkan masalah kesehatan, seperti penyakit jantung, obesitas, tekanan darah tinggi, dan depresi. Dengan mengelola stres, kesehatan mental Anda akan lebih mungkin terjaga. Cobalah kelola stres dengan cara berolahraga setiap hari, menyisihkan waktu untuk diri sendiri, menjaga pola makan, tidur yang cukup, serta hindari alkohol dan obat-obatan.
3.  Bersosialisasi
    Cobalah untuk lebih banyak bersosialisasi, khususnya dengan orang-orang yang Anda percayai. Bersosialisasi dengan seseorang yang Anda percayai, baik itu teman, anggota keluarga, atau kolega, dapat membantu menjaga kesehatan mental. Anda mungkin merasa lebih baik jika dapat secara terbuka berbagi apa yang Anda alami dengan seseorang yang peduli dengan Anda.
4.  Tetapkan tujuan yang realistis
    Tujuan akan membantu Anda meningkatkan motivasi dan menciptakan perubahan yang Anda inginkan. Menetapkan tujuan yang realistis dapat membantu meningkatkan kesehatan dan hubungan dengan orang lain, termasuk meningkatkan produktivitas di tempat kerja. Dalam menjaga kesehatan mental, ada beberapa tujuan realistis yang sebaiknya Anda terapkan, yaitu: Melatih self-love (menghargai dan mencintai diri sendiri), Jaga dan sayangi tubuh Anda (misalnya dengan rutin berolahraga dan makan sehat), Temukan cara baru untuk mengelola stres, kecemasan, atau depresi, Dapatkan dukungan (dari teman dan keluarga atau dengan memulai terapi).
5.  Jangan malu berkonsultasi dengan profesional
    Stres, kecemasan, dan perasaan sedih adalah bagian dari kehidupan sehari-hari, tapi jika emosi tersebut terus-menerus Anda rasakan, itu mungkin pertanda akan sesuatu yang lebih serius. Memiliki perasaan negatif adalah hal normal, jadi jangan malu berkonsultasi dengan profesional jika Anda merasa tidak dapat mengatasi stres yang Anda hadapi, tidak dapat mengendalikan emosi, atau depresi mengganggu kemampuan Anda untuk menjalani kehidupan sehari-hari. Ingatlah bahwa Anda tidak sendirian, dan ada hal-hal yang dapat Anda lakukan untuk menjaga kesehatan mental.
''';

      case 'Demam Berdarah':
        return '''
Demam berdarah atau DBD disebabkan oleh virus Dengue. Seseorang bisa terjangkit demam berdarah jika digigit oleh nyamuk Aedes aegypti dan Aedes albopictus yang telah terinfeksi virus Dengue terlebih dahulu. Nyamuk penyebab demam berdarah biasanya aktif dan menggigit pada pagi dan sore hari. Nyamuk ini biasanya hidup di genangan air yang tenang dan dasarnya bersih, seperti genangan air di ban mobil, sampah plastik, atau tempat minum hewan. Demam berdarah tidak menular antar manusia secara langsung. Namun, ibu hamil dapat menularkan demam berdarah kepada janin yang dikandungnya selama masa kehamilan atau ketika proses persalinan.
Faktor risiko demam berdarah ada beberapa faktor yang dapat meningkatkan risiko pasien mengalami demam berdarah dengan gejala lebih berat, antara lain:
1. Anak-anak atau lansia
2. Ibu hamil
3. Memiliki daya tahan tubuh yang lemah
4. Pernah menderita demam berdarah sebelumnya

Gejala Demam Berdarah pada umumnya seseorang akan demam yang berlangsung selama 3 hari. Demam bisa mencapai suhu 39-40°C
dan sulit turun walaupun pasien telah mengkonsumsi obat penurun panas.
Selain demam, ada beberapa gejala lain yang dapat menyertainya, yaitu:
1. Lemas & Sakit kepala hebat
2. Nyeri di bagian belakang mata
3. Sakit otot dan sendi
4. Hilang nafsu makan
5. Mual dan muntah
6. Ruam kemerahan yang timbul atau tidak timbul

Selanjutnya, demam akan turun dan pasien merasa lebih baik. Namun, pada fase ini, trombosit justru sedang turun drastis dan terjadi kebocoran pada pembuluh darah. Akibatnya, pasien berisiko mengalami perdarahan dan syok karena pembuluh darah kehilangan banyak cairan. Fase setelah demam turun merupakan fase kritis sehingga pasien harus diawasi secara ketat. 
Tanda bahaya yang perlu diawasi pada fase ini antara lain:
1. Nyeri perut yang berat
2. Muntah-muntah tidak kunjung berhenti
3. Lemas setelah sudah merasa membaik
4. Gelisah
5. Gusi berdarah atau mimisan
6. Muntah berdarah
7. Buang air besar berdarah
8. Jantung berdebar
9. Napas cepat
10. Kulit dingin, pucat, dan basah

Pengobatan Demam Berdarah
Tidak ada obat khusus yang dapat membunuh virus Dengue. Perawatan pasien demam berdarah berfokus untuk mengatasi gejala, menjaga energi pasien, dan meningkatkan kekebalan tubuhnya. Dengan demikian, diharapkan virus dapat dibasmi oleh daya tahan tubuh pasien. Penanganan demam berdarah tahap awal bisa dilakukan di rumah selama tidak terdapat tanda bahaya. Namun, selama perawatan mandiri, pasien harus diawasi secara ketat. Selain itu, untuk mempercepat pemulihan, pasien perlu:
1. Mencukupi kebutuhan cairan dengan minuman selain air putih, seperti susu, jus buah, cairan isotonik, oralit, atau air beras
2. Mengonsumsi makanan dengan gizi lengkap dan seimbang
3. Beristirahat yang cukup
4. Menjaga suhu tubuh di bawah 39°C dengan menggunakan kompres hangat, mandi atau berendam air hangat (tidak panas), mengatur suhu ruangan yang sejuk, dan tidak memakai baju yang tidak terlalu tebal
5. Minum paracetamol jika demam naik melebihi 390C atau jika sakit kepala dan nyeri otot terasa mengganggu

Jika terjadi tanda bahaya DBD, pasien harus segera dibawa ke IGD rumah sakit. Pengobatan yang diberikan di rumah sakit berupa:
1. Cairan Infus
2. Pemantauan tekanan darah, kadar trombosit, kadar gula, kadar elektrolit darah, dan fungsi hati
3. Transfusi darah jika terjadi komplikasi perdarahan yang parah

Pencegahan demam berdarah bisa dilakukan dengan menjalankan program pemberantasan sarang nyamuk (PSN) dengan 3M Plus, yaitu:
1. Menguras atau membershkan penampungan air
2. Menutup rapat penampungan air
3. Menguras atau membershkan penampungan air

Plus pencegahan tambahan, seperti fogging atau memperbaiki parit yang tidak lancar PSN 3M Plus ini harus dilakukan secara berkala untuk menciptakan lingkungan yang bersih dan terbebas dari nyamuk penyebab demam berdarah. DBD juga bisa dicegah dengan menjalani vaksin dengue. Vaksin dengue yang tersedia di Indonesia dapat diberikan sejak usia 6 tahun pada anak yang belum atau sudah pernah terinfeksi demam berdarah.
''';

      default:
        return healthInfo['description'] ?? '';
    }
  }
}

