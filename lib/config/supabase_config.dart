import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  static const String supabaseUrl = 'https://twsikshxxekbmytztget.supabase.co';
  static const String supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InR3c2lrc2h4eGVrYm15dHp0Z2V0Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mzk4OTU4NDMsImV4cCI6MjA1NTQ3MTg0M30.XCfAGKXivcaYtwJ0-F3--VAGS1FB37d1t8pV_wp8cBc';

  static Future<void> initSupabase() async {
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
    );
  }

  static final client = Supabase.instance.client;
} 