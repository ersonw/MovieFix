flutter run -d chrome --web-renderer html --web-hostname 192.168.1.11 --web-port 8080 --no-sound-null-safety

flutter build web --web-renderer html --release --no-sound-null-safety

find ./lib |xargs md5 >> version
