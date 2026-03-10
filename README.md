<h1 align="center">🎌 Anime Hub</h1>

<p align="center">
A Flutter application for anime fans to explore <b>latest anime releases, trending titles, trailers, and detailed anime information</b>.
</p>

<p align="center">
Built with ❤️ using <b>Flutter</b> and powered by the <b>Jikan API</b>.
</p>

---

<h2>📱 Features</h2>

<ul>
<li>✨ <b>Latest Releases</b> – Stay updated with newly released anime</li>
<li>🔎 <b>Anime Search</b> – Quickly find your favorite anime</li>
<li>🎬 <b>Trailer Support</b> – Watch anime trailers directly in the app</li>
<li>📖 <b>Anime Details</b> – View synopsis, rating, popularity, and more</li>
<li>🔥 <b>Trending Anime</b> – Discover currently popular anime</li>
<li>⚡ <b>Fast UI</b> – Smooth experience built with Flutter</li>
</ul>

---

<h2>🏗 Architecture</h2>

<p>The application follows an <b>MVC-inspired architecture</b> and uses <b>Provider</b> for state management.</p>

<pre>
lib
│
├── models
│   └── anime.dart
│
├── presentation
│   ├── home_screen.dart
│   ├── anime_detail_screen.dart
│   ├── new_releases_screen.dart
│   ├── search_screen.dart
│   └── main_navigation.dart
│
├── providers
│   ├── home_provider.dart
│   ├── anime_detail_provider.dart
│   └── search_provider.dart
│
├── services
│   └── api_service.dart
│
├── theme
│
└── main.dart
</pre>

---

<h2>🧠 State Management</h2>

<p>
The app uses <b>Provider</b> with <b>ChangeNotifier</b> to efficiently manage and update UI state.
</p>

---

<h2>🌐 API Used</h2>

<p>
This project uses the <b>Jikan API</b>, an unofficial MyAnimeList REST API.
</p>

<ul>
<li>Anime details</li>
<li>Anime trailers</li>
<li>Trending anime</li>
<li>Latest releases</li>
<li>Search functionality</li>
</ul>

<p>
API Documentation:<br>
<a href="https://docs.api.jikan.moe/">https://docs.api.jikan.moe/</a>
</p>

---

<h2>🛠 Tech Stack</h2>

<ul>
<li>Flutter</li>
<li>Dart</li>
<li>Provider (State Management)</li>
<li>MVC Architecture</li>
<li>Jikan REST API</li>
</ul>

---

<h2>⚙️ Installation</h2>

<h3>1. Clone the repository</h3>

<pre>
git clone https://github.com/Kunalkarmavat/Anime_Hub.git
</pre>

<h3>2. Navigate to the project</h3>

<pre>
cd Anime_Hub
</pre>

<h3>3. Install dependencies</h3>

<pre>
flutter pub get
</pre>

<h3>4. Run the application</h3>

<pre>
flutter run
</pre>

---

<h2>📸 Screenshots</h2>

<p align="center">
<img src="https://github.com/user-attachments/assets/e5c15cb6-6b8a-43f9-8c81-1c9bdd6f9d9e" width="250"/>
<img src="https://github.com/user-attachments/assets/5301b028-b03e-4f40-8d98-d9207a378b51" width="250"/>
<img src="https://github.com/user-attachments/assets/daebdc5b-dd5a-4796-9d51-9fa18e466b79" width="250"/>
  
</p>

---

<h2>👨‍💻 Author</h2>

<p>
<b>Kunal Karmavat</b><br>
<a href="https://github.com/Kunalkarmavat">GitHub Profile</a>
</p>

---

<h2>⭐ Support</h2>

<p>
If you like this project:
</p>

<ul>
<li>⭐ Star the repository</li>
<li>🍴 Fork the project</li>
<li>📢 Share it with anime fans</li>
</ul>

<p align="center">
🎌 Built with Flutter for anime lovers
</p>
