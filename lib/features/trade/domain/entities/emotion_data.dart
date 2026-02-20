class EmotionData {
  const EmotionData({
    required this.preTradeEmotion,
    required this.postTradeEmotion,
    this.tags = const [],
  });

  final String preTradeEmotion;
  final String postTradeEmotion;
  final List<String> tags;
}
