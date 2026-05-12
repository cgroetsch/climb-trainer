-- Climb Trainer Pro — Database Schema
-- Run this in your Supabase SQL Editor

-- Profiles
CREATE TABLE IF NOT EXISTS profiles (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  goal TEXT,
  location TEXT,
  height_cm INTEGER,
  weight_kg NUMERIC(5,1),
  birth_year INTEGER,
  created_at TIMESTAMPTZ DEFAULT now()
);

-- Workouts
CREATE TABLE IF NOT EXISTS workouts (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  profile_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
  type TEXT NOT NULL,
  duration_min INTEGER,
  date DATE NOT NULL DEFAULT CURRENT_DATE,
  notes TEXT,
  completed BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT now()
);

-- Meals
CREATE TABLE IF NOT EXISTS meals (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  profile_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
  meal_type TEXT NOT NULL CHECK (meal_type IN ('breakfast','lunch','dinner','snack')),
  description TEXT,
  calories INTEGER,
  protein_g NUMERIC(6,1),
  carbs_g NUMERIC(6,1),
  fat_g NUMERIC(6,1),
  photo_url TEXT,
  date DATE NOT NULL DEFAULT CURRENT_DATE,
  created_at TIMESTAMPTZ DEFAULT now()
);

-- Stats
CREATE TABLE IF NOT EXISTS stats (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  profile_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
  stat_type TEXT NOT NULL,
  value TEXT NOT NULL,
  unit TEXT,
  date DATE NOT NULL DEFAULT CURRENT_DATE,
  notes TEXT,
  created_at TIMESTAMPTZ DEFAULT now()
);

-- Daily Goals
CREATE TABLE IF NOT EXISTS daily_goals (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  profile_id UUID REFERENCES profiles(id) ON DELETE CASCADE UNIQUE,
  calories INTEGER DEFAULT 2300,
  protein_g INTEGER DEFAULT 90,
  carbs_g INTEGER DEFAULT 250,
  fat_g INTEGER DEFAULT 80,
  updated_at TIMESTAMPTZ DEFAULT now()
);

-- Enable Row Level Security
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE workouts ENABLE ROW LEVEL SECURITY;
ALTER TABLE meals ENABLE ROW LEVEL SECURITY;
ALTER TABLE stats ENABLE ROW LEVEL SECURITY;
ALTER TABLE daily_goals ENABLE ROW LEVEL SECURITY;

-- RLS Policies (anon access for single-user mode)
CREATE POLICY anon_select_profiles ON profiles FOR SELECT TO anon USING (true);
CREATE POLICY anon_insert_profiles ON profiles FOR INSERT TO anon WITH CHECK (true);

CREATE POLICY anon_select_workouts ON workouts FOR SELECT TO anon USING (true);
CREATE POLICY anon_insert_workouts ON workouts FOR INSERT TO anon WITH CHECK (true);
CREATE POLICY anon_delete_workouts ON workouts FOR DELETE TO anon USING (true);

CREATE POLICY anon_select_meals ON meals FOR SELECT TO anon USING (true);
CREATE POLICY anon_insert_meals ON meals FOR INSERT TO anon WITH CHECK (true);
CREATE POLICY anon_delete_meals ON meals FOR DELETE TO anon USING (true);

CREATE POLICY anon_select_stats ON stats FOR SELECT TO anon USING (true);
CREATE POLICY anon_insert_stats ON stats FOR INSERT TO anon WITH CHECK (true);
CREATE POLICY anon_delete_stats ON stats FOR DELETE TO anon USING (true);

CREATE POLICY anon_select_goals ON daily_goals FOR SELECT TO anon USING (true);
CREATE POLICY anon_insert_goals ON daily_goals FOR INSERT TO anon WITH CHECK (true);
CREATE POLICY anon_update_goals ON daily_goals FOR UPDATE TO anon USING (true);
