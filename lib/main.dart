
import 'package:flutter/material.dart';

void main() => runApp(const VybeApp());

const Color purple = Color(0xFF3347B0); // Electric blue
const Color pink = Color(0xFFF5D547); // Butter yellow
const Color orange = Color(0xFFF18B52); // Tangerine

class Song {
  final String title, artist, image, duration;
  const Song(this.title, this.artist, this.image, this.duration);
}

const List<Song> songs = [
  Song('Golden Hour', 'JVKE',
      'https://images.unsplash.com/photo-1470225620780-dba8ba36b745?w=600', '3:29'),
  Song('Until I Found You', 'Stephen Sanchez',
      'https://images.unsplash.com/photo-1516280440614-37939bbacd81?w=600', '2:57'),
  Song('Night Changes', 'One Direction',
      'https://images.unsplash.com/photo-1492684223066-81342ee5ff30?w=600', '3:46'),
  Song('Perfect', 'Ed Sheeran',
      'https://images.unsplash.com/photo-1511379938547-c1f69419868d?w=600', '4:23'),
  Song('Die With A Smile', 'Lady Gaga',
      'https://images.unsplash.com/photo-1501386761578-eac5c94b800a?w=600', '4:11'),
  Song('Daylight', 'David Kushner',
      'https://images.unsplash.com/photo-1478737270239-2f02b77fc618?w=600', '3:33'),
];

class VybeApp extends StatefulWidget {
  const VybeApp({super.key});

  @override
  State<VybeApp> createState() => _VybeAppState();
}

class _VybeAppState extends State<VybeApp> {
  bool isDark = false;

  @override
  Widget build(BuildContext context) {
    final bg = isDark
        ? const Color(0xFF211F32)
        : const Color(0xFFF7F3E8);
    final surface =
        isDark ? const Color(0xFF2D2942) : Colors.white;
    final text =
        isDark ? Colors.white : const Color(0xFF292139);
    final muted = isDark ? Colors.white60 : Colors.black54;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'VYBE',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: bg,
        colorScheme: ColorScheme.fromSeed(
          seedColor: purple,
          brightness: isDark ? Brightness.dark : Brightness.light,
        ),
      ),
      home: MusicHome(
        isDark: isDark,
        onThemeChanged: () => setState(() => isDark = !isDark),
        bg: bg,
        surface: surface,
        text: text,
        muted: muted,
      ),
    );
  }
}

class MusicHome extends StatefulWidget {
  final bool isDark;
  final VoidCallback onThemeChanged;
  final Color bg, surface, text, muted;

  const MusicHome({
    super.key,
    required this.isDark,
    required this.onThemeChanged,
    required this.bg,
    required this.surface,
    required this.text,
    required this.muted,
  });

  @override
  State<MusicHome> createState() => _MusicHomeState();
}

class _MusicHomeState extends State<MusicHome> {
  int tab = 0;
  int current = 0;
  bool playing = false;
  String search = '';
  final Set<int> liked = {};

  Song get activeSong => songs[current];

  void play(int index) {
    setState(() {
      current = index;
      playing = true;
    });
  }

  void toggleLike(int index) {
    setState(() {
      liked.contains(index) ? liked.remove(index) : liked.add(index);
    });
  }

  void next() {
    setState(() {
      current = (current + 1) % songs.length;
      playing = true;
    });
  }

  void previous() {
    setState(() {
      current = (current - 1 + songs.length) % songs.length;
      playing = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      homePage(),
      searchPage(),
      likedPage(),
      profilePage(),
    ];

    return Scaffold(
      backgroundColor: widget.bg,
      body: SafeArea(child: pages[tab]),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: widget.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 15,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (playing) miniPlayer(),
            NavigationBar(
              height: 68,
              backgroundColor: widget.surface,
              indicatorColor: pink.withOpacity(0.25),
              selectedIndex: tab,
              onDestinationSelected: (i) => setState(() => tab = i),
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.home_outlined),
                  selectedIcon: Icon(Icons.home_rounded),
                  label: 'Home',
                ),
                NavigationDestination(
                  icon: Icon(Icons.search_rounded),
                  label: 'Explore',
                ),
                NavigationDestination(
                  icon: Icon(Icons.favorite_border),
                  selectedIcon: Icon(Icons.favorite),
                  label: 'Liked',
                ),
                NavigationDestination(
                  icon: Icon(Icons.person_outline),
                  selectedIcon: Icon(Icons.person),
                  label: 'Profile',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // HOME SCREEN

  Widget homePage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(11),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [purple, Color(0xFF5267D5)],
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Icon(Icons.graphic_eq_rounded,
                    color: Colors.white, size: 25),
              ),
              const SizedBox(width: 10),
              Text('VYBE.',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w900,
                    color: widget.text,
                    letterSpacing: -1,
                  )),
              const Spacer(),
              themeButton(),
              const SizedBox(width: 7),
              GestureDetector(
                onTap: () => setState(() => tab = 3),
                child: const CircleAvatar(
                  radius: 21,
                  backgroundColor: Color(0xFFFFF0B8),
                  child: Text('M',
                      style: TextStyle(
                          color: Color(0xFF3347B0),
                          fontWeight: FontWeight.bold,
                          fontSize: 18)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 28),
          Text('HEY, MUSIC LOVER ✨',
              style: TextStyle(
                  color: widget.isDark ? pink : purple,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2)),
          const SizedBox(height: 7),
          Text('Find your rhythm.',
              style: TextStyle(
                  color: widget.text,
                  fontSize: 29,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -1)),
          const SizedBox(height: 5),
          Text('Your world. Your music. Your mood.',
              style: TextStyle(color: widget.muted, fontSize: 13)),
          const SizedBox(height: 25),
          Container(
            height: 205,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF3347B0),
                  Color(0xFF5267D5),
                  Color(0xFFF18B52),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(26),
            ),
            child: Stack(
              children: [
                Positioned(
                  right: -10,
                  bottom: -20,
                  child: Icon(Icons.headphones_rounded,
                      size: 185, color: Colors.white.withOpacity(0.18)),
                ),
                Padding(
                  padding: const EdgeInsets.all(22),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.22),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text('✦  EDITOR\'S PICK',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1)),
                      ),
                      const Spacer(),
                      const Text('Your soundtrack\nstarts here.',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 27,
                              height: 1.15,
                              fontWeight: FontWeight.w900)),
                      const SizedBox(height: 12),
                      ElevatedButton.icon(
                        onPressed: () => play(0),
                        icon: const Icon(Icons.play_arrow_rounded),
                        label: const Text('Play mix'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: purple,
                          elevation: 0,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),
          sectionHeading('Pick your mood', 'FEEL IT'),
          const SizedBox(height: 14),
          SizedBox(
            height: 43,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                moodChip('☀️', 'Happy', pink),
                moodChip('🌙', 'Chill', purple),
                moodChip('⚡', 'Party', orange),
                moodChip('🎸', 'Indie', const Color(0xFF7185D5)),
                moodChip('🌧️', 'Sad', const Color(0xFF7487B8)),
              ],
            ),
          ),
          const SizedBox(height: 28),
          sectionHeading('Trending right now', 'HOT 🔥'),
          const SizedBox(height: 14),
          SizedBox(
            height: 185,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                trendingCard(0, 'Viral hits', 'The songs everyone loves'),
                trendingCard(2, 'Late night', 'For your 2 AM thoughts'),
                trendingCard(4, 'Main character', 'Your moment starts now'),
              ],
            ),
          ),
          const SizedBox(height: 26),
          sectionHeading('Recently played', 'YOUR MIX'),
          const SizedBox(height: 8),
          ...List.generate(4, (i) => songTile(i)),
        ],
      ),
    );
  }

  Widget themeButton() {
    return GestureDetector(
      onTap: widget.onThemeChanged,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
        decoration: BoxDecoration(
          color: widget.isDark
              ? const Color(0xFF3A3652)
              : const Color(0xFFFFF1C7),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          children: [
            Icon(
              widget.isDark ? Icons.nightlight_round : Icons.wb_sunny_rounded,
              color: widget.isDark ? pink : orange,
              size: 17,
            ),
            const SizedBox(width: 5),
            Text(widget.isDark ? 'Dark' : 'Light',
                style: TextStyle(
                    color: widget.text,
                    fontWeight: FontWeight.bold,
                    fontSize: 11)),
          ],
        ),
      ),
    );
  }

  Widget sectionHeading(String title, String label) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style: TextStyle(
                color: widget.text,
                fontSize: 19,
                fontWeight: FontWeight.w800)),
        Text(label,
            style: const TextStyle(
                color: purple,
                fontSize: 10,
                fontWeight: FontWeight.bold,
                letterSpacing: 1)),
      ],
    );
  }

  Widget moodChip(String emoji, String label, Color color) {
    return Container(
      margin: const EdgeInsets.only(right: 9),
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: color.withOpacity(widget.isDark ? 0.2 : 0.12),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: color.withOpacity(0.25)),
      ),
      child: Center(
        child: Text('$emoji  $label',
            style: TextStyle(
                color: widget.text,
                fontWeight: FontWeight.w600,
                fontSize: 12)),
      ),
    );
  }

  Widget trendingCard(int index, String title, String subtitle) {
    return GestureDetector(
      onTap: () => play(index),
      child: Container(
        width: 145,
        margin: const EdgeInsets.only(right: 13),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(17),
                  child: Image.network(
                    songs[index].image,
                    height: 125,
                    width: 145,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      height: 125,
                      color: purple.withOpacity(0.2),
                      child: const Icon(Icons.music_note, color: purple),
                    ),
                  ),
                ),
                Positioned(
                  right: 9,
                  bottom: 9,
                  child: CircleAvatar(
                    radius: 17,
                    backgroundColor: purple,
                    child: const Icon(Icons.play_arrow,
                        color: Colors.white, size: 21),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(title,
                style: TextStyle(
                    color: widget.text, fontWeight: FontWeight.bold)),
            Text(subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: widget.muted, fontSize: 11)),
          ],
        ),
      ),
    );
  }

  // SEARCH SCREEN

  Widget searchPage() {
    final filtered = songs.asMap().entries.where((e) {
      return e.value.title.toLowerCase().contains(search.toLowerCase()) ||
          e.value.artist.toLowerCase().contains(search.toLowerCase());
    }).toList();

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 14),
          Text('Explore music',
              style: TextStyle(
                  color: widget.text,
                  fontSize: 28,
                  fontWeight: FontWeight.w900)),
          const SizedBox(height: 7),
          Text('There is a song for every feeling.',
              style: TextStyle(color: widget.muted)),
          const SizedBox(height: 23),
          TextField(
            onChanged: (value) => setState(() => search = value),
            style: TextStyle(color: widget.text),
            decoration: InputDecoration(
              hintText: 'Songs, artists, albums...',
              prefixIcon: const Icon(Icons.search, color: purple),
              filled: true,
              fillColor: widget.surface,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(17),
                  borderSide: BorderSide.none),
            ),
          ),
          const SizedBox(height: 20),
          Text('All tracks',
              style: TextStyle(
                  color: widget.text,
                  fontSize: 19,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Expanded(
            child: filtered.isEmpty
                ? Center(
                    child: Text('No songs found 🎧',
                        style: TextStyle(color: widget.muted)))
                : ListView(
                    children: filtered.map((e) => songTile(e.key)).toList(),
                  ),
          ),
        ],
      ),
    );
  }

  // FAVOURITES SCREEN

  Widget likedPage() {
    final list = liked.toList();
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 15),
          Text('Your love list 💗',
              style: TextStyle(
                  color: widget.text,
                  fontSize: 27,
                  fontWeight: FontWeight.w900)),
          const SizedBox(height: 6),
          Text('The tracks that hit different.',
              style: TextStyle(color: widget.muted)),
          const SizedBox(height: 20),
          Expanded(
            child: list.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.favorite_rounded,
                            size: 65, color: pink),
                        const SizedBox(height: 12),
                        Text('Nothing here yet!',
                            style: TextStyle(
                                color: widget.text,
                                fontSize: 20,
                                fontWeight: FontWeight.bold)),
                        Text('Tap the heart on a song to save it.',
                            style: TextStyle(color: widget.muted)),
                      ],
                    ),
                  )
                : ListView(
                    children: list.map((i) => songTile(i)).toList(),
                  ),
          ),
        ],
      ),
    );
  }

  // UPDATED PROFILE SCREEN

  Widget profilePage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('My space.',
                  style: TextStyle(
                      color: widget.text,
                      fontSize: 28,
                      fontWeight: FontWeight.w900)),
              themeButton(),
            ],
          ),
          const SizedBox(height: 6),
          Text('Your music identity, all in one place.',
              style: TextStyle(color: widget.muted)),
          const SizedBox(height: 22),

          // PROFILE CARD
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF3347B0),
                  Color(0xFF5267D5),
                  Color(0xFFF18B52),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(26),
              boxShadow: [
                BoxShadow(
                  color: purple.withOpacity(0.25),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 11, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text('✦ VYBE MEMBER',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1)),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 3),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 12,
                      ),
                    ],
                  ),
                  child: const CircleAvatar(
                    radius: 43,
                    backgroundColor: Color(0xFFFFF1C7),
                    child: Icon(Icons.person_rounded,
                        size: 52, color: purple),
                  ),
                ),
                const SizedBox(height: 13),
                const Text('Music Lover',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 23)),
                const SizedBox(height: 5),
                const Text('Living life one song at a time ♡',
                    style: TextStyle(color: Colors.white70, fontSize: 12)),
                const SizedBox(height: 17),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 15, vertical: 7),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text('✧  FIND YOUR FREQUENCY  ✧',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 25),

          // LISTENING STATS
          Text('YOUR MUSIC STATS',
              style: TextStyle(
                  color: widget.muted,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5)),
          const SizedBox(height: 12),
          Row(
            children: [
              statCard('${songs.length}', 'Tracks', Icons.music_note),
              const SizedBox(width: 10),
              statCard('${liked.length}', 'Liked', Icons.favorite),
              const SizedBox(width: 10),
              statCard('04', 'Playlists', Icons.queue_music),
            ],
          ),
          const SizedBox(height: 25),

          // FAVOURITE SONGS PREVIEW
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Your top picks',
                  style: TextStyle(
                      color: widget.text,
                      fontSize: 19,
                      fontWeight: FontWeight.w800)),
              Text('${liked.length} SAVED',
                  style: const TextStyle(
                      color: purple,
                      fontSize: 10,
                      fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 10),
          if (liked.isEmpty)
            Container(
              padding: const EdgeInsets.all(17),
              decoration: BoxDecoration(
                color: widget.surface,
                borderRadius: BorderRadius.circular(17),
              ),
              child: Row(
                children: [
                  const Icon(Icons.favorite_border, color: pink, size: 25),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Your favourite songs will appear here. Start saving the tracks you love!',
                      style: TextStyle(color: widget.muted, fontSize: 12),
                    ),
                  ),
                ],
              ),
            )
          else
            ...liked.take(3).map((i) => songTile(i)),

          const SizedBox(height: 23),

          // SETTINGS
          Text('PREFERENCES',
              style: TextStyle(
                  color: widget.muted,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5)),
          const SizedBox(height: 10),
          settingsTile(
            Icons.person_outline,
            'Edit profile',
            'Personalise your music identity',
            onTap: () => showMessage('Profile editing coming soon!'),
          ),
          settingsTile(
            Icons.notifications_none,
            'Notifications',
            'Stay updated with your music',
            onTap: () => showMessage('Notifications coming soon!'),
          ),
          settingsTile(
            Icons.palette_outlined,
            'Appearance',
            widget.isDark ? 'Dark mode enabled' : 'Light mode enabled',
            trailing: Switch(
              value: widget.isDark,
              activeColor: purple,
              onChanged: (_) => widget.onThemeChanged(),
            ),
          ),
          settingsTile(
            Icons.headphones_outlined,
            'Audio quality',
            'Standard quality',
            onTap: () => showMessage('Audio settings coming soon!'),
          ),
          settingsTile(
            Icons.info_outline,
            'About VYBE',
            'Version 1.0.0 • Made with ♡',
            onTap: () => showMessage('VYBE — Find your frequency.'),
          ),
          const SizedBox(height: 23),
          Center(
            child: Text('MADE FOR THE LOVE OF MUSIC ♡',
                style: TextStyle(
                    color: widget.muted,
                    fontSize: 10,
                    letterSpacing: 2,
                    fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: purple,
      ),
    );
  }

  Widget statCard(String value, String label, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 17, horizontal: 5),
        decoration: BoxDecoration(
          color: widget.surface,
          borderRadius: BorderRadius.circular(17),
          border: Border.all(
            color: widget.isDark
                ? Colors.white.withOpacity(0.05)
                : purple.withOpacity(0.06),
          ),
        ),
        child: Column(
          children: [
            Icon(icon, color: pink, size: 22),
            const SizedBox(height: 8),
            Text(value,
                style: TextStyle(
                    color: widget.text,
                    fontSize: 21,
                    fontWeight: FontWeight.w900)),
            Text(label,
                style: TextStyle(color: widget.muted, fontSize: 11)),
          ],
        ),
      ),
    );
  }

  Widget settingsTile(
    IconData icon,
    String title,
    String subtitle, {
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 9),
      decoration: BoxDecoration(
        color: widget.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          padding: const EdgeInsets.all(9),
          decoration: BoxDecoration(
            color: purple.withOpacity(0.12),
            borderRadius: BorderRadius.circular(11),
          ),
          child: Icon(icon, color: purple, size: 21),
        ),
        title: Text(title,
            style: TextStyle(
                color: widget.text,
                fontWeight: FontWeight.bold,
                fontSize: 14)),
        subtitle: Text(subtitle,
            style: TextStyle(color: widget.muted, fontSize: 11)),
        trailing: trailing ??
            Icon(Icons.chevron_right, color: widget.muted),
      ),
    );
  }

  // SONG ROW

  Widget songTile(int index) {
    final song = songs[index];
    final isLiked = liked.contains(index);

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 4),
      onTap: () => play(index),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          song.image,
          width: 53,
          height: 53,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(
            width: 53,
            height: 53,
            color: purple.withOpacity(0.2),
            child: const Icon(Icons.music_note, color: purple),
          ),
        ),
      ),
      title: Text(song.title,
          style: TextStyle(
              color: widget.text,
              fontWeight: FontWeight.bold,
              fontSize: 14)),
      subtitle: Text(song.artist,
          style: TextStyle(color: widget.muted, fontSize: 12)),
      trailing: IconButton(
        onPressed: () => toggleLike(index),
        icon: Icon(
          isLiked ? Icons.favorite : Icons.favorite_border,
          color: isLiked ? pink : widget.muted,
        ),
      ),
    );
  }

  // MINI PLAYER

  Widget miniPlayer() {
    return GestureDetector(
      onTap: openPlayer,
      child: Container(
        margin: const EdgeInsets.fromLTRB(12, 8, 12, 5),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF3347B0), Color(0xFF5267D5)],
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(9),
              child: Image.network(
                activeSong.image,
                width: 42,
                height: 42,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                    const Icon(Icons.music_note, color: Colors.white),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(activeSong.title,
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold)),
                  Text(activeSong.artist,
                      style: const TextStyle(
                          color: Colors.white70, fontSize: 11)),
                ],
              ),
            ),
            IconButton(
              onPressed: () => setState(() => playing = !playing),
              icon: Icon(
                playing ? Icons.pause_rounded : Icons.play_arrow_rounded,
                color: pink,
              ),
            ),
            IconButton(
              onPressed: next,
              icon: const Icon(Icons.skip_next_rounded, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  void openPlayer() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PlayerPage(
          song: () => activeSong,
          playing: () => playing,
          toggle: () => setState(() => playing = !playing),
          next: () => setState(next),
          previous: () => setState(previous),
          dark: widget.isDark,
          text: widget.text,
        ),
      ),
    ).then((_) => setState(() {}));
  }
}

// FULL PLAYER SCREEN WITH GLOWING ALBUM ART

class PlayerPage extends StatefulWidget {
  final Song Function() song;
  final bool Function() playing;
  final VoidCallback toggle, next, previous;
  final bool dark;
  final Color text;

  const PlayerPage({
    super.key,
    required this.song,
    required this.playing,
    required this.toggle,
    required this.next,
    required this.previous,
    required this.dark,
    required this.text,
  });

  @override
  State<PlayerPage> createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  double progress = 0.35;

  @override
  Widget build(BuildContext context) {
    final song = widget.song();

    return Scaffold(
      backgroundColor:
          widget.dark ? const Color(0xFF211F32) : const Color(0xFFF7F3E8),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.keyboard_arrow_down_rounded,
              color: widget.text, size: 30),
        ),
        centerTitle: true,
        title: Text('VYBE PLAYER',
            style: TextStyle(
                color: widget.text,
                fontSize: 11,
                letterSpacing: 2,
                fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // NEON GLOWING ALBUM ART
            AnimatedContainer(
              duration: const Duration(milliseconds: 350),
              padding: const EdgeInsets.all(9),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                gradient: const LinearGradient(
                    colors: [purple, pink, orange]),
                boxShadow: [
                  BoxShadow(
                    color: purple.withOpacity(widget.dark ? 0.55 : 0.3),
                    blurRadius: widget.dark ? 40 : 25,
                    spreadRadius: widget.dark ? 8 : 3,
                  ),
                  BoxShadow(
                    color: pink.withOpacity(widget.dark ? 0.35 : 0.15),
                    blurRadius: 45,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(23),
                child: Image.network(
                  song.image,
                  width: 290,
                  height: 290,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 290,
                    height: 290,
                    color: purple.withOpacity(0.2),
                    child: const Icon(Icons.music_note,
                        size: 90, color: purple),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 35),
            Text(song.title,
                style: TextStyle(
                    color: widget.text,
                    fontSize: 26,
                    fontWeight: FontWeight.w900)),
            const SizedBox(height: 7),
            Text(song.artist,
                style: const TextStyle(color: purple, fontSize: 15)),
            const SizedBox(height: 28),
            Slider(
              value: progress,
              activeColor: pink,
              inactiveColor: purple.withOpacity(0.2),
              onChanged: (v) => setState(() => progress = v),
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('1:12', style: TextStyle(color: Colors.grey)),
                Text('3:29', style: TextStyle(color: Colors.grey)),
              ],
            ),
            const SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    widget.previous();
                    setState(() {});
                  },
                  icon: const Icon(Icons.skip_previous_rounded),
                  iconSize: 43,
                  color: widget.text,
                ),
                const SizedBox(width: 18),
                GestureDetector(
                  onTap: () {
                    widget.toggle();
                    setState(() {});
                  },
                  child: Container(
                    width: 68,
                    height: 68,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [purple, Color(0xFF5267D5)],
                      ),
                    ),
                    child: Icon(
                      widget.playing()
                          ? Icons.pause_rounded
                          : Icons.play_arrow_rounded,
                      color: pink,
                      size: 42,
                    ),
                  ),
                ),
                const SizedBox(width: 18),
                IconButton(
                  onPressed: () {
                    widget.next();
                    setState(() {});
                  },
                  icon: const Icon(Icons.skip_next_rounded),
                  iconSize: 43,
                  color: widget.text,
                ),
              ],
            ),
            const SizedBox(height: 28),
            const Text('♫  FIND YOUR FREQUENCY  ♫',
                style: TextStyle(
                    color: purple,
                    fontSize: 10,
                    letterSpacing: 2,
                    fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
