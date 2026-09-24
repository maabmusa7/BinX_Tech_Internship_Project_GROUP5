enum TopicCategory { all, dailyLife, travel, social, career }

extension TopicCategoryX on TopicCategory {
  String get label {
    switch (this) {
      case TopicCategory.all:
        return 'All';
      case TopicCategory.dailyLife:
        return 'Daily Life';
      case TopicCategory.travel:
        return 'Travel';
      case TopicCategory.social:
        return 'Social';
      case TopicCategory.career:
        return 'Career';
    }
  }

  /// القيمة يلي بترسل للـ API — null يعني "All" (بدون فلترة)
  String? get apiValue {
    switch (this) {
      case TopicCategory.all:
        return null;
      case TopicCategory.dailyLife:
        return 'DailyLife';
      case TopicCategory.travel:
        return 'Travel';
      case TopicCategory.social:
        return 'Social';
      case TopicCategory.career:
        return 'Career';
    }
  }
}